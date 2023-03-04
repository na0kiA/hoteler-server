# frozen_string_literal: true

module V1
  class HelpfulOrNotController < ApplicationController
    before_action :authenticate_v1_user!

    def show
      # REVIEW: = Review.find_by(id: params[:review_id])
      # helpfulnesses = Helpfulness.find_by(id: params[:id])
      if Helpfulness.current_v1_user.exists?(review_id: params[:review_id])
        render json: { helpful: true }, status: :ok
      else
        render json: { helpful: false }, status: :ok
      end
    end
  end
end
