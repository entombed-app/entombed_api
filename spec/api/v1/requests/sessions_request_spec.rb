require 'rails_helper'

RSpec.describe 'Sessions Requests' do
  describe 'create' do
    it 'can find a user by email & password' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password123'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)
      created_user = User.last

      find_user = {
        email: 'ex@ample.com',
        password: 'password123'
      }
      post '/api/v1/login', headers: headers, params: JSON.generate(find_user)

      expect(response.status).to eq 200

      found_user = JSON.parse(response.body, symbolize_names: true)
      expect(found_user).is_a? Hash
      expect(found_user).to have_key(:data)
      expect(found_user[:data]).is_a? Hash
      expect(found_user[:data]).to have_key(:id)
      expect(found_user[:data][:id]).is_a? String
      expect(found_user[:data]).to have_key(:type)
      expect(found_user[:data][:type]).to eq "user"
      expect(found_user[:data]).to have_key(:attributes)
      expect(found_user[:data][:attributes]).is_a? Hash
      expect(found_user[:data][:attributes]).not_to have_key(:password)
      expect(found_user[:data][:attributes]).not_to have_key(:password_digest)
      expect(found_user[:data][:attributes]).to have_key(:email)
      expect(found_user[:data][:attributes][:email]).is_a? String
      expect(found_user[:data][:attributes]).to have_key(:name)
      expect(found_user[:data][:attributes][:name]).is_a? String
      expect(found_user[:data][:attributes]).to have_key(:date_of_birth)
      expect(found_user[:data][:attributes][:date_of_birth].to_date).is_a? Date
      expect(found_user[:data][:attributes]).to have_key(:obituary)
      expect(found_user[:data][:attributes][:obituary]).is_a? String
      expect(found_user[:data][:attributes]).to have_key(:etd)
      expect(found_user[:data][:attributes][:etd].to_date).is_a? Date
    end

    it 'returns an error for non existent users' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password123'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)
      created_user = User.last

      find_user = {
        email: 'foo',
        password: 'bar'
      }
      post '/api/v1/login', headers: headers, params: JSON.generate(find_user)

      expect(response.status).to eq 403
      
      error_message = JSON.parse(response.body, symbolize_names: true)
      expect(error_message[:error]).to eq 'Username or password incorrect'
    end

    it 'returns the same error for incorrect password' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password123'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)
      created_user = User.last

      find_user = {
        email: 'ex@ample.com',
        password: 'bar'
      }
      post '/api/v1/login', headers: headers, params: JSON.generate(find_user)

      expect(response.status).to eq 403
      
      error_message = JSON.parse(response.body, symbolize_names: true)
      expect(error_message[:error]).to eq 'Username or password incorrect'
    end
  end
end