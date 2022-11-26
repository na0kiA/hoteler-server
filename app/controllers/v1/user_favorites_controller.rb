# frozen_string_literal: true

class V1::UserFavoritesController < ApplicationController
  before_action :authenticate_v1_user!

  def index
    favorites = Favorite.eager_load(:hotel, hotel: [:hotel_images]).where(user_id: params[:id])
    render json: favorites, each_serializer: UserFavoriteSerializer
  end
end
