class ApplicantPortalController < ApplicationController
  before_action :require_authentication

  def show
    @applicant = current_user.applicant_profile
  end
end
