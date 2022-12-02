# frozen_string_literal: true

module V1
  class ImagesController < ApplicationController
    before_action :authenticate_v1_user!

    def index
      resource = S3_BUCKET.presigned_post(
        key: "uploads/hoteler/#{SecureRandom.uuid}/${filename}", success_action_status: "201", acl: "public-read", content_length_range: 1..(10.megabytes)
      )
      render json: { url: resource.url, fields: resource.fields }
    end
  end
end
