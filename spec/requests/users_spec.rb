require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    it "should create new User" do
      post '/users', params: {email: 'ku@example.com', name: 'joe'}, as: :json
      responseJson = JSON.parse(response.body)

      expect(responseJson['id']).to be
      expect(User.find(responseJson['id']).email).to eq('ku@example.com')
      expect(User.find(responseJson['id']).name).to eq('joe')
    end
  end

  describe "GET /users" do
    let!(:users) { FactoryBot.create_list(:user, 7) }

    before(:each) do
      get '/users', as: :json
    end

    it "should return success" do
      expect(response).to have_http_status(200)
    end

    it "should return all users" do
      expect(JSON.parse(response.body).size).to eq(7)
    end
  end
end
