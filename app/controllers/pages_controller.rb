class PagesController < ApplicationController
  before_action :redirect_if_authenticated, only: [:home]

	def home;end

  private

  def redirect_if_authenticated
    redirect_to dashboard_path if current_user
  end
end