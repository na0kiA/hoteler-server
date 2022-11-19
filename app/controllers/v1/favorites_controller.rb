# frozen_string_literal: true

class V1::FavoritesController < ApplicationController
  before_action :authenticate_v1_user!
  before_action :set_hotel, only: [:create]

  def create
    if hotel_not_exists?
      render_json_bad_request_with_custom_errors(
        title: '存在しないホテルです。',
        body: '存在しないホテルに対しては「お気に入り」を押せません。'
      )
    elsif your_hotel?
      render_json_bad_request_with_custom_errors(
        title: 'お気に入りに登録できませんでした。',
        body: '自分のホテルはお気に入りに登録できません。'
      )
    elsif @hotel.favorites.exists?(user_id: current_v1_user.id)
      redirect_to(action: :destroy) and return
    else
      current_v1_user.favorites.create(hotel_id: @hotel.id)
      render json: {}, status: :ok
    end
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_v1_user.id, hotel_id: params[:hotel_id])
    if favorite.blank?
      render_json_bad_request_with_custom_errors(
        title: '「お気に入り」を取り消せません',
        body: '「お気に入り」を押していないので取り消せません'
      )
    elsif favorite.user_id != current_v1_user.id
      render json: {}, status: :bad_request
    elsif your_hotel?
      render_json_bad_request_with_custom_errors(
        title: 'お気に入りを解除できませんでした。',
        body: '自分のホテルはお気に入りは解除できません。'
      )
    else
      favorite.destroy
      render json: {}, status: :ok
    end
  end

  private

    def set_hotel
      @hotel = Hotel.find_by(id: params[:hotel_id])
    end

    def my_hotel?
      current_v1_user.id == set_hotel.user_id
    end

    def accepted?
      set_hotel.accepted?
    end

    def hotel_not_exists?
      set_hotel.blank? || (!accepted? && !my_hotel?)
    end

    def your_hotel?
      !accepted? && current_v1_user.id == set_hotel.user_id
    end
end
