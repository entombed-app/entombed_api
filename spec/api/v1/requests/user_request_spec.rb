require 'rails_helper'

RSpec.describe 'User Requests' do
  describe 'show' do
    it 'displays serialized info for one user' do
      user = create(:user)
      get "/api/v1/user/#{user.id}"

      expect(response.status).to eq 200
    end
  end
end