# frozen_string_literal: true

module V1
  class HelpfulnessesController < ApplicationController
    before_action :authenticate_v1_user!

    def show
      if Helpfulness.exists?(review_id: params[:review_id], user: current_v1_user)
        render json: { helpful: true }, status: :ok
      else
        render json: { helpful: false }, status: :ok
      end
    end

    def create
      review = Review.find_by(id: params[:review_id])
      if review.blank?
        render_json_bad_request_with_custom_errors(
          title: "存在しない口コミです",
          body: "存在しない口コミに対しては「参考になった」を押せません"
        )
      elsif review.helpfulnesses.exists?(user_id: current_v1_user.id)
      # elsif Helpfulness.exists?(user_id: current_v1_user.id)
        # redirect_to(action: :destroy) and return
        # Helpfulness.find_by(user_id: current_v1_user.id, review_id: params[:review_id]).destroy
        render json: { title: "既に参考になったを押しています" }, status: :ok
      else
        current_v1_user.helpfulnesses.create(review_id: review.id)
        render json: { user_id: current_v1_user.id }, status: :ok
      end
    end

    def destroy
      helpfulness = Helpfulness.find_by(user_id: current_v1_user.id, review_id: params[:review_id])
      if helpfulness.blank?
        render_json_bad_request_with_custom_errors(
          title: "「参考になった」を取り消せません",
          body: "「参考になった」を押していないので取り消せません"
        )
      elsif helpfulness.user_id != current_v1_user.id
        render json: {}, status: :bad_request
      else
        helpfulness.destroy
        render json: { user_id: current_v1_user.id }, status: :ok
      end
    end
  end
end
