require 'rails_helper'

RSpec.describe 'User Requests' do
  describe 'show' do
    it 'displays serialized info for one user' do
      user = create(:user)
      get "/api/v1/user/#{user.id}"

      expect(response.status).to eq 200

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

    it 'has an etd which is later than birth date' do
      user = create(:user)
      get "/api/v1/user/#{user.id}"
      expect(response.status).to eq 200
      serialized_user = JSON.parse(response.body, symbolize_names: true)
      birth = serialized_user[:data][:attributes][:date_of_birth].to_date
      death = serialized_user[:data][:attributes][:etd].to_date

      expect(birth).to be < death
    end
  end
end