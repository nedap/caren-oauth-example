class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:caren]

  # Sets up an account from the omniauth data received from the CarenProvider
  # @param auth [Hash] the omniauth meta data
  # @return [Object] the created/found account
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.first_name     = auth.info.first_name
      user.email          = auth.info.email
      user.password       = Devise.friendly_token[0,20]

      # Add the user credentials for using the API of Caren
      user.token          = auth.credentials.token
      user.refresh_token  = auth.credentials.refresh_token
      user.expires_at     = Time.zone.at(auth.credentials.expires_at).to_datetime
    end
  end

  # Creates a OAuth2::AccessToken so we can query the api, more info can be
  # found at: https://github.com/intridea/oauth2
  # @return [OAuth2::AccessToken] the acces token object
  def access_token
    OAuth2::AccessToken.new(client, token)
  end

private

  # Create a OAuth client for the API, more info can be found at:
  # https://github.com/intridea/oauth2
  # @return [OAuth2::Client] the oauth client
  def client
    OAuth2::Client.new(
      Rails.application.secrets.caren_app_id,
      Rails.application.secrets.caren_secret,
      :site => 'https://www.carenzorgt.nl'
    )
  end

end
