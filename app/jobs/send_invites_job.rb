class SendInvitesJob < ApplicationJob
  queue_as :default

  def perform(user_ids)
    logger.info("Submitting #{user_ids.size} users to Sendgrid API...");

    # XXX: beware of permissions to access the users by id
    users = User.select("email, name").where(id: user_ids);

    sender = SendgridSender.new(Rails.application.credentials.sendgrid_api_key)
    result = sender.send_invites(users)

    if result[:success]
      logger.info("#{users.size} invites sent!")
    else
      logger.error("Failed to send emails on Sendgrid", result)
    end
  end

  def self.schedule_invites(user_ids)
    # respect Sendgrid API limits https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html
    user_ids.each_slice(Rails.application.config.sendgrid_recipients_limit) do |slice|
      SendInvitesJob.perform_later(slice)
    end
  end
end
