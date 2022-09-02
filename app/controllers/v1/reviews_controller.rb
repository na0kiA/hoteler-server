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
      review_form = ReviewForm.new(attributes: review_params, user_id: current_v1_user.id, hotel_id: accepted_hotel_params.id)
      if review_form.save
        render json: review_form
      else
        render json: review_form.errors, status: :bad_request
      end
    end

    # def edit
    #   @review_form = ReviewForm.new(review: @review)
    #   render json: @review_form
    # end

    def update
      # binding.break
      review_form = ReviewForm.new(attributes: update_params, review: @review, user_id: @review.user_id, hotel_id: @review.hotel_id)
      if review_form.save && @review.user_id == current_v1_user.id
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
      params.require(:review).permit(:title, :content, :five_star_rate, :file_url, :key).merge(user_id: current_v1_user.id, hotel_id: accepted_hotel_params.id)
    end

    # reviewのupdateのrouting(v1/reviews/:id)にホテルのidが含まれていないため専用のupdate_paramsを用意
    def update_params
      params.require(:review).permit(:title, :content, :five_star_rate, :key, :file_url).merge(user_id: current_v1_user.id, hotel_id: @review.hotel_id)
    end

    def set_review
      @review = Review.find(params[:id])
    end

    def accepted_hotel_params
      Hotel.accepted.find(params[:hotel_id])
    end
  end
end
