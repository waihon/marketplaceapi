class ApplicationController < ActionController::API
  # From version 2.2.0, Devise no more respond to XML and JSON formats for
  # sessions/new and registrations/new. Therefore we need to explicitly
  # declare that we want it to respond to JSON.
  # https://github.com/plataformatec/devise/issues/2260
  # https://github.com/plataformatec/devise/issues/2209
  # https://github.com/plataformatec/devise/issues/2215
  respond_to :json

  # Why need to include this module in ApplicationController?
  include Authenticable
end
