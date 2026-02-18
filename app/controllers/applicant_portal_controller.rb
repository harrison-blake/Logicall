class ApplicantPortalController < ApplicationController
  before_action :require_authentication

  def show
    @applicant = current_user.applicant_profile
  end

  def upload
    @applicant = current_user.applicant_profile
    if params[:attachments].present?
      @applicant.attachments.attach(params[:attachments])
      redirect_to applicant_portal_path, notice: "Attachments uploaded successfully."
    else
      redirect_to applicant_portal_path, alert: "Please select files to upload."
    end
  end
end
