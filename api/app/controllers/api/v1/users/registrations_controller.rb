class Api::V1::Users::RegistrationsController < ApplicationController
  # skip_before_action :authenticate_user

  def create
    raise ArgumentError, 'BadRequest Parameter' if payload.blank?
    user = User.create!(sign_up_params.merge(uid: payload[0]['sub']))
    render json: user, status: :ok
  end

  private
  def sign_up_params
    params.require(:registration).permit(:email)
  end

  def token_from_request_headers
    request.headers["Authorization"]&.split&.last
  end

  def token
    params[:token] || token_from_request_headers
  end

  def jwks
    jwks = JSON.parse(RestClient.get(
      'https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com'
    ).body)
  end

  def payload
    payload, _ = JWT.decode(token, nil, true, { algorithm: ['RS256'], jwks: jwks })
  end
end