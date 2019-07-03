class ApplicationController < ActionController::Base

  protect_from_forgery
  http_basic_authenticate_with name: "ASO2019", password: "cipale"

end
