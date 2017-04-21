module Authenticable
  # Overrides Devise method to suit our needs, that is finding the current user
  # by the authentication token that is going to be sent on each request to
  # the API.
  # Once the client sign ins a user with the correct credientials, the API will
  # return the authentication token from that actual user, and each time that
  # client requests for a protected page we will need to featch the user from
  # that token that comes in the request and it could be as a param or as a
  # header.
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers["Authorization"])
  end

  # A simple authorization mechanism to prevent unsigned-in users to access the API.
  def authenticate_with_token!
    render json: { errors: "Not authenticated" },
           status: :unauthorized unless current_user.present?
  end
end
