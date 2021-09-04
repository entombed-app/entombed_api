require 'rails_helper'

RSpec.describe 'Image attachment requests' do
  describe 'create' do
    it 'can attach an image' do
      user = create(:user)
      post "/api/v1/users/#{user.id}/images", params: {
            image: fixture_file_upload('profile2.png')
      }

      expect(response.status).to eq 201
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
      expect(serialized_user[:data][:attributes]).to have_key(:profile_picture_url)
      expect(serialized_user[:data][:attributes][:profile_picture_url]).to eq nil
      expect(serialized_user[:data][:attributes]).to have_key(:obituary)
      expect(serialized_user[:data][:attributes][:obituary]).is_a? String
      expect(serialized_user[:data][:attributes]).to have_key(:etd)
      expect(serialized_user[:data][:attributes][:etd].to_date).is_a? Date
      expect(serialized_user[:data][:attributes]).to have_key(:images_urls)
      expect(serialized_user[:data][:attributes][:images_urls]).is_a? Array
      expect(serialized_user[:data][:attributes][:images_urls].length).to eq 1
      expect(serialized_user[:data][:attributes][:images_urls][0]).is_a? String
    end

    it 'can attach multiple images' do
      user = create(:user)
      post "/api/v1/users/#{user.id}/images", params: {
            image: fixture_file_upload('profile2.png')
      }
      post "/api/v1/users/#{user.id}/images", params: {
            image: fixture_file_upload('profile.png')
      }

      expect(response.status).to eq 201
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
      expect(serialized_user[:data][:attributes]).to have_key(:profile_picture_url)
      expect(serialized_user[:data][:attributes][:profile_picture_url]).to eq nil
      expect(serialized_user[:data][:attributes]).to have_key(:obituary)
      expect(serialized_user[:data][:attributes][:obituary]).is_a? String
      expect(serialized_user[:data][:attributes]).to have_key(:etd)
      expect(serialized_user[:data][:attributes][:etd].to_date).is_a? Date
      expect(serialized_user[:data][:attributes]).to have_key(:images_urls)
      expect(serialized_user[:data][:attributes][:images_urls]).is_a? Array
      expect(serialized_user[:data][:attributes][:images_urls].length).to eq 2
      expect(serialized_user[:data][:attributes][:images_urls][0]).is_a? String
      expect(serialized_user[:data][:attributes][:images_urls][1]).is_a? String
    end
  end
end