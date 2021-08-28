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
        password_confirmation: 'password',
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

    it 'returns serialized user upon creation' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password',
        password_confirmation: 'password',
        profile_picture: 'www.img-example.com'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)

      serialized_user = JSON.parse(response.body, symbolize_names: true)

      expect(serialized_user).is_a? Hash
      expect(serialized_user).to have_key(:data)
      expect(serialized_user[:data]).is_a? Hash
      expect(serialized_user[:data]).to have_key(:id)
      expect(serialized_user[:data][:id]).is_a? String
      expect(serialized_user[:data]).to have_key(:type)
      expect(serialized_user[:data][:type]).to eq "user"
      expect(serialized_user[:data]).to have_key(:attributes)
      expect(serialized_user[:data][:attributes]).is_a? Hash
      expect(serialized_user[:data][:attributes]).not_to have_key(:password)
      expect(serialized_user[:data][:attributes]).not_to have_key(:password_digest)
      expect(serialized_user[:data][:attributes]).to have_key(:email)
      expect(serialized_user[:data][:attributes][:email]).is_a? String
      expect(serialized_user[:data][:attributes]).to have_key(:name)
      expect(serialized_user[:data][:attributes][:name]).is_a? String
      expect(serialized_user[:data][:attributes]).to have_key(:date_of_birth)
      expect(serialized_user[:data][:attributes][:date_of_birth].to_date).is_a? Date
      expect(serialized_user[:data][:attributes]).to have_key(:profile_picture)
      expect(serialized_user[:data][:attributes][:profile_picture]).is_a? String
      expect(serialized_user[:data][:attributes]).to have_key(:obituary)
      expect(serialized_user[:data][:attributes][:obituary]).is_a? String
      expect(serialized_user[:data][:attributes]).to have_key(:etd)
      expect(serialized_user[:data][:attributes][:etd].to_date).is_a? Date
    end

    it 'does not create with mismatched password and confirmation' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password',
        password_confirmation: 'notthepassword',
        profile_picture: 'www.img-example.com'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)

      expect(response.status).to eq 401
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to eq({ error: 'password and confirmation must match', status: 401 })
    end
  end
end