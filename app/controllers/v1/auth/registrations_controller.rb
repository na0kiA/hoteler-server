module V1
  module Auth
    class RegistrationsController < ApiController
      private

      def sign_up_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end
