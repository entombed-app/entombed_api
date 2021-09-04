require 'rails_helper'

RSpec.describe 'Users Requests' do
  describe 'create' do
    it 'can create a user with no profile picture' do
      post '/api/v1/users', params:
      {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password123'
      }
      expect(response).to have_http_status(201)

      JSON.parse(response.body, symbolize_names: true)
      created_user = User.last

      expect(created_user.email).to eq 'ex@ample.com'
      expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(created_user.name).to eq 'Jane Doe'
      expect(created_user.obituary).to eq 'Tedious and brief'
      expect(created_user.password).to eq nil
      expect(created_user.password_digest).is_a? String
      expect(created_user.profile_picture.attached?).to eq false
    end
    
    it 'can create a user with a profile picture' do
      post '/api/v1/users', params:
      {
          email: 'ex@ample.com',
          date_of_birth: '2001/02/03',
          name: 'Jane Doe',
          obituary: 'Tedious and brief',
          password: 'password123',
          profile_picture: fixture_file_upload('profile.png')
      }
        expect(response).to have_http_status(201)

        JSON.parse(response.body, symbolize_names: true)
        created_user = User.last

        expect(created_user.email).to eq 'ex@ample.com'
        expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
        expect(created_user.name).to eq 'Jane Doe'
        expect(created_user.obituary).to eq 'Tedious and brief'
        expect(created_user.password).to eq nil
        expect(created_user.password_digest).is_a? String
        expect(created_user.profile_picture.attached?).to eq true
    end

    it 'returns serialized profile url' do
      user = create(:user)
      user.profile_picture.attach(
        io: File.open('./public/profile_pictures/profile-picture.png'),
        filename: 'profile-picture.png',
        content_type: 'application/png'
      )
      get "/api/v1/users/#{user.id}"

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
      expect(serialized_user[:data][:attributes]).to have_key(:profile_picture_url)
      expect(serialized_user[:data][:attributes][:profile_picture_url]).is_a? String
      expect(serialized_user[:data][:attributes]).to have_key(:obituary)
      expect(serialized_user[:data][:attributes][:obituary]).is_a? String
      expect(serialized_user[:data][:attributes]).to have_key(:etd)
      expect(serialized_user[:data][:attributes][:etd].to_date).is_a? Date
    end 
    
    it 'updates a users profile picture' do
        post '/api/v1/users', params:
        {
          email: 'ex@ample.com',
          date_of_birth: '2001/02/03',
          name: 'Jane Doe',
          obituary: 'Tedious and brief',
          password: 'password123',
          profile_picture: fixture_file_upload('profile.png')
       } 
        JSON.parse(response.body, symbolize_names: true)
        
        created_user = User.last

        patch "/api/v1/users/#{created_user.id}/profile_picture", params: 
        {
            profile_picture: fixture_file_upload('profile2.png')
        }
  
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
        expect(serialized_user[:data][:attributes]).to have_key(:profile_picture_url)
        expect(serialized_user[:data][:attributes][:profile_picture_url]).is_a? String
        expect(serialized_user[:data][:attributes]).to have_key(:obituary)
        expect(serialized_user[:data][:attributes][:obituary]).is_a? String
        expect(serialized_user[:data][:attributes]).to have_key(:etd)
        expect(serialized_user[:data][:attributes][:etd].to_date).is_a? Date
    end

    it 'updates a users profile picture if there is no image' do
        post '/api/v1/users', params:
        {
          email: 'ex@ample.com',
          date_of_birth: '2001/02/03',
          name: 'Jane Doe',
          obituary: 'Tedious and brief',
          password: 'password123',
          profile_picture: nil
       } 
        JSON.parse(response.body, symbolize_names: true)
        
        created_user = User.last

        patch "/api/v1/users/#{created_user.id}/profile_picture", params: 
        {
            profile_picture: fixture_file_upload('profile2.png')
        }

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
        expect(serialized_user[:data][:attributes]).to have_key(:profile_picture_url)
        expect(serialized_user[:data][:attributes][:profile_picture_url]).is_a? String
        expect(serialized_user[:data][:attributes]).to have_key(:obituary)
        expect(serialized_user[:data][:attributes][:obituary]).is_a? String
        expect(serialized_user[:data][:attributes]).to have_key(:etd)
        expect(serialized_user[:data][:attributes][:etd].to_date).is_a? Date
    end

    it 'returns 400 response if no image is attached' do
        post '/api/v1/users', params:
        {
          email: 'ex@ample.com',
          date_of_birth: '2001/02/03',
          name: 'Jane Doe',
          obituary: 'Tedious and brief',
          password: 'password123',
          profile_picture: fixture_file_upload('profile.png')
       } 
        JSON.parse(response.body, symbolize_names: true)

        created_user = User.last

        patch "/api/v1/users/#{created_user.id}/profile_picture", params: 
        {
            profile_picture: nil
        }

        expect(response.status).to eq 400
      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:error]).to eq 'No image file detected'
    end
  end
end

