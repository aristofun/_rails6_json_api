require 'rails_helper'

RSpec.describe "Invites", type: :request do
  describe "POST /invites" do
    before(:each) do
      FactoryBot.create(:user, id: 1, email: 'my1@example.com', name: 'Me1')
      FactoryBot.create(:user, id: 2, email: 'my2@example.com', name: 'Me2')
    end

    it "should create new Job" do
      post '/invites', params: {user_ids: [1, 2]}, as: :json
      expect(response.status).to eq(202)
      expect(SendInvitesJob)
        .to have_been_enqueued.with([1, 2])
    end

    # todo: move to jobs specs folder
    #
    it "should create new Sendgrid Request" do
      sendgrid_result = {success: true};

      allow_any_instance_of(SendgridSender).to receive(:send_invites) do |*args|
        expect(args[1].map { |id| {email: id.email, name: id.name} })
          .to contain_exactly({email: 'my2@example.com', name: 'Me2'},
                              {email: 'my1@example.com', name: 'Me1'})
      end.and_return(sendgrid_result)

      SendInvitesJob.perform_now([1, 2, 3])
    end
  end
end
