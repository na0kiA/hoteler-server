# frozen_string_literal: true

class V1::FavoritesController < ApplicationController
  before_action :authenticate_v1_user!
  before_action :set_hotel, only: %i[create destroy]

  def create
    if hotel_not_exists?
      hotel_not_exist_with_custom_errors
    elsif your_hotel?
      it_is_a_your_hotel_with_custom_errors
    elsif @hotel.favorites.exists?(user: current_v1_user)
      redirect_to(action: :destroy) and return
    else
      current_v1_user.favorites.create(hotel: @hotel)
      render json: {}, status: :ok
    end
  end

  def destroy
    favorite = Favorite.find_by(user: current_v1_user, hotel: @hotel)
    if favorite.blank?
      hotel_not_exist_with_custom_errors
    elsif favorite.user != current_v1_user
      render json: {}, status: :bad_request
    elsif your_hotel?
      it_is_a_your_hotel_with_custom_errors
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
      current_v1_user == set_hotel.user
    end

    def accepted?
      set_hotel.accepted?
    end

    def hotel_not_exists?
      set_hotel.blank? || (!accepted? && !my_hotel?)
    end

    def your_hotel?
      !accepted? && current_v1_user == set_hotel.user
    end

    def hotel_not_exist_with_custom_errors
      render_json_bad_request_with_custom_errors(
        title: "存在しないホテルです。",
        body: "存在しないホテルに対しては「お気に入り」を押せません。"
      )
    end

    def it_is_a_your_hotel_with_custom_errors
      render_json_bad_request_with_custom_errors(
        title: "お気に入りを操作できませんでした。",
        body: "自分のホテルはお気に入りに追加、及び削除ができません。"
      )
    end
end
