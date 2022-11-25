# frozen_string_literal: true

module V1
  class ReviewsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :set_review, only: %i[show destroy update]
    before_action :set_accepted_hotel, only: %i[index create]

    def index
      if @accepted_hotel.present?
        reviews = @accepted_hotel.reviews
        render json: reviews, each_serializer: ReviewIndexSerializer
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
      review = Review.new(review_params)
      if reviewed_by_other_than_hotel_manager?
        if review.save && current_v1_user.send_notifications.create(user: @accepted_hotel.user, hotel: @accepted_hotel, message: review.title)
          render json: {}, status: :ok
        else
          render json: review.errors, status: :bad_request
        end
      else
        render_json_bad_request_with_custom_errors(title: "書き込みに失敗しました。", body: "ホテル運営者様は自身のホテルに口コミを書くことは出来ません。")
      end
    end

    def update
      if @review.present? && authenticated?
        @review.update(update_params)
        render json: {}, status: :ok
      else
        render json: @review.errors, status: :bad_request
      end
    end

    def destroy
      if authenticated?
        @review.destroy
        render json: @review, status: :ok
      else
        render json: @review.errors, status: :bad_request
      end
    end

    private

      def authenticated?
        @review.present? && @review.user_id == current_v1_user.id
      end

      def reviewed_by_other_than_hotel_manager?
        current_v1_user.id != set_accepted_hotel.user.id
      end

      def review_params
        params.require(:review).permit(:title, :content, :five_star_rate).merge(user_id: current_v1_user.id, hotel_id: set_accepted_hotel.id)
      end

    # reviewのupdateのrouting(v1/reviews/:id)にホテルのidが含まれていないため専用のupdate_paramsを用意
      def update_params
        params.require(:review).permit(:title, :content, :five_star_rate).merge(user_id: current_v1_user.id, hotel_id: @review.hotel_id)
      end

      def set_review
        @review = Review.find(params[:id])
      end

      def set_accepted_hotel
        @accepted_hotel = Hotel.accepted.find(params[:hotel_id])
      end
  end
end
