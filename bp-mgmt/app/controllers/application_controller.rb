##
# Overall controller for our application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
