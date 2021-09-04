require 'rails_helper'

RSpec.describe 'Users Requests' do
  describe 'create' do
    it 'can create a user with correct info' do
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

      expect(response.status).to eq 201
      expect(created_user.email).to eq 'ex@ample.com'
      expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(created_user.name).to eq 'Jane Doe'
      expect(created_user.obituary).to eq 'Tedious and brief'
      expect(created_user.password).to eq nil
      expect(created_user.password_digest).is_a? String
    end

    it 'returns serialized user upon creation' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password'
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
      expect(serialized_user[:data][:attributes]).to have_key(:obituary)
      expect(serialized_user[:data][:attributes][:obituary]).is_a? String
      expect(serialized_user[:data][:attributes]).to have_key(:etd)
      expect(serialized_user[:data][:attributes][:etd].to_date).is_a? Date
    end

    it 'ignores extra data' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password',
        password_confirmation: 'password',
        foo: 'bar',
        baz: 'boop'
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
      expect{created_user.foo}.to raise_error(NameError)
      expect{created_user.baz}.to raise_error(NameError)
    end

    it 'does not create without an email' do
      user_details = {
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)

      expect(response.status).to eq 400
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to eq({ error: 'Missing or incorrect user params', status: 400 })
    end

    it 'does not create without a name' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        obituary: 'Tedious and brief',
        password: 'password'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)

      expect(response.status).to eq 400
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to eq({ error: 'Missing or incorrect user params', status: 400 })
    end

    it 'does not create without date of birth' do
      user_details = {
        email: 'ex@ample.com',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)

      expect(response.status).to eq 400
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to eq({ error: 'Missing or incorrect user params', status: 400 })
    end

    it 'does create without obituary' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        password: 'password'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)
      created_user = User.last

      expect(response.status).to eq 201
      expect(created_user.email).to eq 'ex@ample.com'
      expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(created_user.name).to eq 'Jane Doe'
      expect(created_user.obituary).to eq nil
      expect(created_user.password).to eq nil
      expect(created_user.password_digest).is_a? String
    end

    it 'does create without profile pic' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        obituary: 'Tedious and brief',
        password: 'password'
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
    end
  end

  describe 'show' do
    it 'displays serialized info for one user' do
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

    it 'has an etd which is later than birth date' do
      user = create(:user)
      user.profile_picture.attach(
        io: File.open('./public/profile_pictures/profile-picture.png'),
        filename: 'profile-picture.png',
        content_type: 'application/png'
      )
      get "/api/v1/users/#{user.id}"
      expect(response.status).to eq 200
      serialized_user = JSON.parse(response.body, symbolize_names: true)
      birth = serialized_user[:data][:attributes][:date_of_birth].to_date
      death = serialized_user[:data][:attributes][:etd].to_date

      expect(birth).to be < death
    end


    it 'includes dependent executors' do
      user = create(:user)
      user.executors.create!(name: 'younger bobby', email: 'bob@bee.com', phone: '888-999-1111')
      get "/api/v1/users/#{user.id}"
      expect(response.status).to eq 200
      serialized_user = JSON.parse(response.body, symbolize_names: true)

      expect(serialized_user[:data][:relationships]).is_a? Hash
      expect(serialized_user[:data][:relationships][:executors]).is_a? Hash
      expect(serialized_user[:data][:relationships][:executors][:data]).is_a? Array
      expect(serialized_user[:data][:relationships][:executors][:data].first).to have_key(:id)
      expect(serialized_user[:data][:relationships][:executors][:data].first).to have_key(:type)
      expect(serialized_user[:data][:relationships][:executors][:data].first[:type]).to eq 'executor'
    end

    it 'includes dependent photos' do
      user = create(:user)
      post "/api/v1/users/#{user.id}/attach_image", params: {
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



    it 'raises error for non-existent user' do
      expect {
        get '/api/v1/users/1'
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'update' do
    it 'updates a user' do
      user_details = {
        email: 'ex@ample.com',
        date_of_birth: '2001/02/03',
        name: 'Jane Doe',
        password: 'password'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post '/api/v1/users', headers: headers, params: JSON.generate(user_details)
      created_user = User.last
      expect(response.status).to eq 201
      expect(created_user.email).to eq 'ex@ample.com'
      expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(created_user.name).to eq 'Jane Doe'
      expect(created_user.obituary).to eq nil
      expect(created_user.password).to eq nil
      expect(created_user.password_digest).is_a? String

      updated_user_details = {
        obituary: 'tedious and brief'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      patch "/api/v1/users/#{created_user.id}", headers: headers, params: JSON.generate(updated_user_details)

      expect(response.status).to eq 200
      updated_user = User.find(created_user.id)
      expect(updated_user.email).to eq 'ex@ample.com'
      expect(updated_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(updated_user.name).to eq 'Jane Doe'
      expect(updated_user.obituary).to eq 'tedious and brief'
    end

    it 'can update an obituary to nil' do
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
      expect(response.status).to eq 201
      expect(created_user.email).to eq 'ex@ample.com'
      expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(created_user.name).to eq 'Jane Doe'
      expect(created_user.obituary).to eq 'Tedious and brief'
      expect(created_user.password).to eq nil
      expect(created_user.password_digest).is_a? String

      updated_user_details = {
        obituary: nil
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      patch "/api/v1/users/#{created_user.id}", headers: headers, params: JSON.generate(updated_user_details)

      updated_user = User.find(created_user.id)
      expect(response.status).to eq 200
      expect(updated_user.email).to eq 'ex@ample.com'
      expect(updated_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(updated_user.name).to eq 'Jane Doe'
      expect(updated_user.obituary).to eq nil
    end

    it 'can update all attributes' do
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
      expect(response.status).to eq 201
      expect(created_user.email).to eq 'ex@ample.com'
      expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(created_user.name).to eq 'Jane Doe'
      expect(created_user.obituary).to eq 'Tedious and brief'

      updated_user_details = {
        email: 'new@mail.com',
        date_of_birth: '2004/05/06',
        name: 'Jim Does',
        obituary: 'Exciting and Slow',
        password: 'password123456'
      }
      patch "/api/v1/users/#{created_user.id}", headers: headers, params: JSON.generate(updated_user_details)

      updated_user = User.find(created_user.id)
      expect(response.status).to eq 200
      expect(updated_user.email).to eq 'new@mail.com'
      expect(updated_user.date_of_birth.to_s).to eq '2004-05-06'
      expect(updated_user.name).to eq 'Jim Does'
      expect(updated_user.obituary).to eq 'Exciting and Slow'
      expect(created_user.password_digest).not_to eq(updated_user.password_digest)
    end

    it 'ignores extra attributes' do
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
      expect(response.status).to eq 201
      expect(created_user.email).to eq 'ex@ample.com'
      expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(created_user.name).to eq 'Jane Doe'
      expect(created_user.obituary).to eq 'Tedious and brief'

      updated_user_details = {
        foo: 'var',
        baz: 'bing'
      }
      patch "/api/v1/users/#{created_user.id}", headers: headers, params: JSON.generate(updated_user_details)

      updated_user = User.find(created_user.id)
      expect(updated_user.email).to eq 'ex@ample.com'
      expect(updated_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(updated_user.name).to eq 'Jane Doe'
      expect(updated_user.obituary).to eq 'Tedious and brief'
      expect{updated_user.foo}.to raise_error(NameError)
      expect{updated_user.baz}.to raise_error(NameError)
    end

    it 'errors when trying to delete validated columns' do
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
      expect(response.status).to eq 201
      expect(created_user.email).to eq 'ex@ample.com'
      expect(created_user.date_of_birth.to_s).to eq '2001-02-03'
      expect(created_user.name).to eq 'Jane Doe'
      expect(created_user.obituary).to eq 'Tedious and brief'

      updated_user_details = {
        email: nil
      }
      patch "/api/v1/users/#{created_user.id}", headers: headers, params: JSON.generate(updated_user_details)

      expect(response.status).to eq 400
      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:error]).to eq 'User name, email, birthdate cannot be empty'
    end
  end
end
