# frozen_string_literal: true

module V1
  class ReviewsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :set_review, only: %i[show destroy update]

    def index
      if accepted_hotel_params.present?
        render json: Review.all
      else
        render json: { error: e.message }.to_json, status: :not_found
      end
    end

    def show
      review = Review.find_by(id: @review)
      if review.present?
        render json: review
      else
        render json: { error: e.message }.to_json, status: :not_found
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
      review_form = ReviewForm.new(update_params)
      if review_form.valid? && authenticate?
        ReviewEdit.new(params: review_form.to_deep_symbol, set_review: @review).update
        render json: review_form, status: :ok
      else
        render json: review_form.errors, status: :bad_request
      end
    end

    def destroy
      if authenticate?
        Review.update_zero_rating(set_review: @review)
        @review.destroy
        render json: @review, status: :ok
      else
        render json: @review.errors, status: :bad_request
      end
    end

    private

      def authenticate?
        @review.present? && @review.user_id == current_v1_user.id
      end

      def review_params
        params.require(:review).permit(:title, :content, :five_star_rate, key: []).merge(user_id: current_v1_user.id,
                                                                                         hotel_id: accepted_hotel_params.id)
      end

    # reviewのupdateのrouting(v1/reviews/:id)にホテルのidが含まれていないため専用のupdate_paramsを用意
      def update_params
        params.require(:review).permit(:title, :content, :five_star_rate, key: []).merge(user_id: current_v1_user.id, hotel_id: @review.hotel_id)
      end

      def set_review
        @review = Review.find(params[:id])
      end

      def accepted_hotel_params
        Hotel.accepted.find(params[:hotel_id])
      end
  end
end
