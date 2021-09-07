require 'rails_helper'

RSpec.describe 'Email send' do
  describe 'email' do
    it 'can send emails to user recipients' do
      user = create(:user)
      user_url = "http://localhost:3000/#{user.id}/memorial"
      user.profile_picture.attach(
            io: File.open('./public/profile_pictures/profile-picture.png'),
            filename: 'profile-picture.png',
            content_type: 'application/png'
        )
      user.recipients.create!(name: 'Uncle bobby', email: 'unclebobby@test.com')

      post "/api/v1/users/#{user.id}/email", params: 
      {
          user_url: "http://localhost:3000/#{user.id}/memorial"
      }

      email = UserMailer.send_email(user, user_url)

      expect(email.subject).to eq("Our Condolences")
      expect(email.to[0]).to eq("unclebobby@test.com")
      expect(email.from[0]).to eq("elegy.notify@gmail.com")
      expect(email.body).to include("Sorry to inform you, Uncle bobby")
      expect(email.body).to include("http://localhost:3000/#{user.id}/memorial")
    end

    it 'can send emails to multiple user recipients' do
      user = create(:user)
      user_url = "http://localhost:3000/#{user.id}/memorial"
      user.profile_picture.attach(
            io: File.open('./public/profile_pictures/profile-picture.png'),
            filename: 'profile-picture.png',
            content_type: 'application/png'
        )
      user.recipients.create!(name: 'Uncle bobby', email: 'unclebobby@test.com')
      user.recipients.create!(name: 'Aunty bobby', email: 'auntybobby@test.com')
      user.recipients.create!(name: 'Gary bobby', email: 'garybobby@test.com')
      user.recipients.create!(name: 'Jerry bobby', email: 'Jerrybobby@test.com')
      user.recipients.create!(name: 'Cousin bobby', email: 'Cousinbobby@test.com')

      post "/api/v1/users/#{user.id}/email", params: 
      {
          user_url: "http://localhost:3000/#{user.id}/memorial"
      }

      email = UserMailer.send_email(user, user_url)

      expect(email.subject).to eq("Our Condolences")
      expect(email.to[0]).to be_a(String)
      expect(email.from[0]).to be_a(String)
      expect(email.body).to include("Sorry to inform you,")
      expect(email.body).to include("http://localhost:3000/#{user.id}/memorial")
    end

    it 'will return an error if user not found' do
      expect {
        post "/api/v1/users/8000/email"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'will return an error if no url is present' do
      user = create(:user)
      user_url = "http://localhost:3000/#{user.id}/memorial"
      user.profile_picture.attach(
            io: File.open('./public/profile_pictures/profile-picture.png'),
            filename: 'profile-picture.png',
            content_type: 'application/png'
        )
      user.recipients.create!(name: 'Uncle bobby', email: 'unclebobby@test.com')

      post "/api/v1/users/#{user.id}/email", params: 
      {
          user_url: nil
      }

      expect(response.status).to eq 400
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to eq({ error: 'No memorial url detected' })
    end
  end
end

    