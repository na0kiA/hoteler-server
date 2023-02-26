# frozen_string_literal: true

ActiveModelSerializers.config.key_transform = :camel_lower
ActiveModel::Serializer.config.adapter = :json