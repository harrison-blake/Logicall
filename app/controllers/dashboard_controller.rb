class DashboardController < ApplicationController
  before_action :require_authentication

  def index
    # This will be the logged-in user's dashboard
  end
end
