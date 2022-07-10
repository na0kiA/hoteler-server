module V1
  class S3Controller < ApplicationController
    def s3_direct_post
      resource = S3_BUCKET.presigned_post(
        key: "uploads/test/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_length_range: 1..(10.megabytes)
      )
      render json: { url: resource.url, fields: resource.fields }
    end

    # KeyからURLの生成
    def file_url
      Aws::S3::Object.new(ENV['S3_BUCKET'], key).public_url
    end
  end
end
