class V1::S3Controller < ApplicationController

  # def signed_url(filename, operation)
  #   signer = Aws::S3::Presigner.new
  #   signer.presigned_url(operation, bucket: ENV['S3_BUCKET_NAME'], key: filename)
  # end

  def s3_direct_post
    resource = S3_BUCKET.presigned_post(
      key: "uploads/test/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_length_range: 1..(10.megabytes))
    render json: { url: resource.url, fields: resource.fields }
  end
end
