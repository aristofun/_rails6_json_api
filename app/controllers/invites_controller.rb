class InvitesController < ApplicationController
  # POST /invites
  def create
    if invite_params[:user_ids]
      SendInvitesJob::schedule_invites(invite_params[:user_ids])
      render status: :accepted
    else
      render status: :unprocessable_entity
    end
  end

  private

  def invite_params
    params.require(:invite).permit(user_ids: []) # only ids array allowed
  end
end
