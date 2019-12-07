require 'sendgrid-ruby'

class SendgridSender
  include SendGrid

  # Set up SendgridWebApi instance
  def initialize(api_key)
    @sg = SendGrid::API.new(api_key: api_key)
  end

  #
  # expecting [{email: '...', name: '...'}, ...] array as `users` param
  # returns {status_code: '', message: '...', headers: '', success: true/false} on response
  #
  def send_invites(users)
    result = {
      success: false,
      status_code: '',
      headers: '',
      message: ''
    };

    if users.size > Rails.application.config.sendgrid_recipients_limit
      result[:message] = I18n.t('sendgrid.limit_exceeded_error')
      return result
    end

    data = {
      personalizations: SendgridSender.personalizations(users),
      subject: I18n.t('sendgrid.invite_email_subject'),
      from: {email: Rails.application.config.admin_email},
      content: [
        {type: "text/plain",
         value: I18n.t('sendgrid.invite_email_body')}
      ]
    }

    begin
      response = @sg.client.mail._("send").post(request_body: data)
      result[:success] = (response.status_code == '202')
      result[:status_code] = response.status_code
      result[:headers] = response.headers
      result[:message] = response.body unless result[:success]
    rescue SocketError, Errno::ECONNREFUSED => e
      result[:success] = false
      result[:message] = "#{e.class.name}: #{e.message}"
    end

    return result;
  end

  # expecting [{email: '...', name: '...'}, ...] array as `users` param
  # returns `personalizations` sendgrid array with %name% substitution
  def self.personalizations(users)
    return users.map do |u|
      {to: [{email: u[:email], name: u[:name]}],
       substitutions: {"%name%" => u[:name]}}
    end
  end
end