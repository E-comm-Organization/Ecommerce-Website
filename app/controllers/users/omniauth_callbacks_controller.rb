# frozen_string_literal: true

# Users::OmniauthCallbacksController handles Google OAuth2 callbacks for user authentication.
# It provides methods to sign in users and handle authentication failures.
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
