class V1::UserFavoritesController < ApplicationController
  before_action :authenticate_v1_user!

  def index
    user = User.find(params[:id])
    favorites = user.favorites.order(id: :desc)
    render json: favorites, each_serializer: UserFavoriteSerializer
  end

end
