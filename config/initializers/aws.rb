Aws.config.update({
                    region: 'ap-northeast-1',
                    credentials: Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID', nil), ENV.fetch('AWS_SECRET_ACCESS_KEY', nil))
                  })

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV.fetch('S3_BUCKET', nil))
