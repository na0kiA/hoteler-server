module V1
  class ImagesController < ApplicationController
    before_action :authenticate_v1_user!

    def signed_url
      resource = S3_BUCKET.presigned_post(
        key: "uploads/hoteler/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_length_range: 1..(10.megabytes)
      )
      render json: { url: resource.url, fields: resource.fields }
    end

    def save_hotel_key
      key = Image.new(hotel_s3_key)
      key&.save
    end

    def save_user_key
      key = Image.new(user_s3_key)
      key&.save
    end

    def file_url
      Aws::S3::Object.new(ENV.fetch('S3_BUCKET', nil), key).public_url
    end

    private

    def hotel_s3_key
      params.require(:image).permit(:hotel_s3_key).merge(user_id: current_v1_user.id)
    end

    def user_s3_key
      params.require(:image).permit(:user_s3_key).merge(user_id: current_v1_user.id)
    end

    def image_id
      Image.find(params[:id])
    end
  end
end
