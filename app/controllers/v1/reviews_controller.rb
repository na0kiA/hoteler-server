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
        render json: review.errors, status: :bad_request
      end
    end

    def create
      # binding.break
      review_form = Review.new(review_params)
      if review_form.save && review_form.present?
        render json: review_form, status: :ok
      else
        render json: review_form.errors, status: :bad_request
      end
    end

    # def create
    #   hotel = Hotel.new(review_params)
    #   if hotel.save && hotel.present?
    #     render json: hotel, status: :ok
    #   else
    #     render json: hotel.errors, status: :bad_request
    #   end
    # end

    def update
      if @review.present? && @review.user.id == current_v1_user.id
        @review.update(review_params)
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
      hotel = Hotel.find(params[:hotel_id])
      params.require(:review).permit(:title, :content).merge(user_id: current_v1_user.id, hotel_id: hotel.id)
    end

    def review_ids
      @review = Review.find(params[:id])
    end

    def hotel_params
      Hotel.find(params[:hotel_id])
    end
  end
end
