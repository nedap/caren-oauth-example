class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def caren
    @user = User.from_omniauth(auth_info)
    if @user.persisted?
      # Set the success message and sign the user in
      flash[:success] = t('devise.sessions.signed_in')
      sign_in @user

      redirect_to root_url
    else
      session["devise.caren_data"] = auth_info
      redirect_to new_account_registration_url
    end
  end

  private

  # Returns the authentication information from the Caren credentials
  # API endpoint. This info is used to create a new user, or find an existing
  # user in our database.
  # @return [Hash] the authentication information
  def auth_info
    request.env['omniauth.auth']
  end
end
