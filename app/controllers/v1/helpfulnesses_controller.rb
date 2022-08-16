module V1
  class HelpfulnessesController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      review = Review.find_by(id: params[:review_id])
      if review.blank?
        render_json_bad_request_with_custom_errors(
          '存在しない口コミです',
          '存在しない口コミに対しては「参考になった」を押せません'
        )
      elsif Helpfulness.exists?(user_id: current_v1_user.id)
        redirect_to(action: :destroy) and return
      else
        current_v1_user.helpfulnesses.create(review_id: review.id)
        render json: {}, status: :ok
      end
    end

    def destroy
      helpfulness = Helpfulness.find_by(user_id: current_v1_user.id, review_id: params[:review_id])
      if helpfulness.blank?
        render_json_bad_request_with_custom_errors(
          '「参考になった」を取り消せません',
          '「参考になった」を押していないので取り消せません'
        )
      else
        helpfulness.destroy
        render json: {}, status: :ok
      end
    end
  end
end
