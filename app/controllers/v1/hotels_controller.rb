module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, only: [create, update, destroy]
  end
end
