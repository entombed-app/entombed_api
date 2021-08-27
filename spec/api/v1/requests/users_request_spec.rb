require 'rails_helper'

RSpec.describe 'Users Requests' do
  describe 'create' do
    it 'can create a user with correct info' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password',
        profile_picture: 'www.img-example.com'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)
      created_user = User.last

      expect(response.status).to eq 201
      expect(created_user.email).to eq 'ex@ample.com'
      expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(created_user.name).to eq 'Jane Doe'
      expect(created_user.obituary).to eq 'Tedious and brief'
      expect(created_user.password).to eq nil
      expect(created_user.password_digest).is_a? String
      expect(created_user.profile_picture).to eq 'www.img-example.com'
    end
  end
end