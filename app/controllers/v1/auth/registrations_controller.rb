# frozen_string_literal: true

module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController

      private

        def sign_up_params
          params.permit(:email, :password, :password_confirmation)
        end
    end
  end
end
