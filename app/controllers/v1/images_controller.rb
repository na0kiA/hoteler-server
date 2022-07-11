module V1
  class ImagesController < ApplicationController
    def generate_s3_presigned_url
      resource = S3_BUCKET.presigned_post(
        key: "uploads/test/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_length_range: 1..(10.megabytes)
      )
      render json: { url: resource.url, fields: resource.fields }
    end

    def convert_key_to_file_url
      Aws::S3::Object.new(ENV.fetch('S3_BUCKET', nil), key).public_url
    end
  end
end