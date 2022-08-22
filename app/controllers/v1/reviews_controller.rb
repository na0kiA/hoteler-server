module V1
  class ReviewsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :review_ids, only: %i[show destroy update]

    def index
      return record_not_found if hotel_params.blank?

      render json: Review.all
    end

    def show
      review = Review.find_by(id: @review)
      if review.present?
        render json: review
      else
        render json: review.errors, status: :not_found
        # record_not_found
      end
    end

    def create
      review_form = Review.new(review_params)
      if review_form.present? && review_form.save
        render json: review_form, status: :ok
      else
        render json: review_form.errors, status: :bad_request
      end
    end

    def update
      if @review.present? && @review.user.id == current_v1_user.id
        @review.update(review_update_params)
        render json: @review, status: :ok
      else
        render json: @review.errors, status: :bad_request
      end
    end

    def destroy
      if @review.present? && @review.user.id == current_v1_user.id
        @review.destroy
        render json: @review, status: :ok
      else
        render json: @review.errors, status: :bad_request
      end
    end

    private

    def review_params
      params.require(:review).permit(:title, :content).merge(user_id: current_v1_user.id, hotel_id: hotel_params.id)
    end

    def review_update_params
      params.require(:review).permit(:title, :content)
    end

    def review_ids
      @review = Review.find(params[:id])
    end

    def hotel_params
      Hotel.accepted.find(params[:hotel_id])
    end
  end
end
