module V1
  class ReviewsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :set_review, only: %i[show destroy update]

    def index
      return record_not_found if accepted_hotel_params.blank?

      render json: Review.all
    end

    def show
      review = Review.find_by(id: @review)
      if review.present?
        render json: review
      else
        render json: review.errors, status: :not_found
      end
    end

    def create
      review_form = ReviewForm.new(review_params)
      if review_form.save
        render json: review_form
      else
        render json: review_form.errors, status: :bad_request
      end
    end

    def update
      review_form = ReviewForm.new(review_params)
      if review_form.valid? && @review.present? && @review.user_id == current_v1_user.id
        ReviewEdit.new(review_form.params).update
        render json: review_form, status: :ok
      else
        render json: review_form.errors, status: :bad_request
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
      params.require(:review).permit(:title, :content, :five_star_rate, key: []).merge(user_id: current_v1_user.id, hotel_id: accepted_hotel_params.id)
    end

    # reviewのupdateのrouting(v1/reviews/:id)にホテルのidが含まれていないため専用のupdate_paramsを用意
    def update_params
      params.require(:review).permit(:title, :content, :five_star_rate, :key).merge(user_id: current_v1_user.id, hotel_id: @review.hotel_id)
    end

    def set_review
      @review = Review.find(params[:id])
    end

    def accepted_hotel_params
      Hotel.accepted.find(params[:hotel_id])
    end
  end
end
