# frozen_string_literal: true

module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      private

        def sign_up_params
          params.permit(:name, :email, :password, :password_confirmation)
        end

        def account_update_params
          params.permit(:name, :email, :image)
        end
    end
  end
end
