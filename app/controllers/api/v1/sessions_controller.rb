class Api::V1::SessionsController < ApplicationController
  # Sign in
  def create
    user_email = params[:session][:email]
    user_password = params[:session][:password]
    user = user_email.present? && User.find_by(email: user_email)

    if user.valid_password? user_password
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200, location: [:api, user] # OK
    else
      render json: { errors: "Invalid email or password" }, status: 422 # Unprocessable Entity
    end
  end

  # Sign out
  def destroy
    user = User.find_by(auth_token: params[:id])
    # Update the authentication token so the last one becomes useless and
    # cannot be used again.
    user.generate_authentication_token!
    user.save
    head 204 # No Content
  end
end
