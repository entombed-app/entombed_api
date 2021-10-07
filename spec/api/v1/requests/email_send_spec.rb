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
      user.executors.create!(name: 'Phineas Tinkerton', email: 'ex@ample.com', phone: '123-456-7890')
      post "/api/v1/users/#{user.id}/email", params: 
      {
          user_url: "http://localhost:3000/#{user.id}/memorial"
      }

      email = UserMailer.send_email(user, user_url)

      expect(email.subject).to eq("Our Condolences")
      expect(email.to[0]).to eq("unclebobby@test.com")
      expect(email.from[0]).to eq("elegy.notify@gmail.com")
      expect(email.body.raw_source).to include("Sorry to inform you, Uncle bobby")
      expect(email.body.raw_source).to include(user_url)
      expect(email.body.raw_source).to include("#{user.name} has passed away. #{user.name} cared for you very much, and wanted to show you how they would like to be remembered.")
      expect(email.body.raw_source).to include("#{user.name} designated Phineas Tinkerton as the executor of this memorial page, if you have any questions you can contact Phineas Tinkerton at 123-456-7890 or ex@ample.com")
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
      user.executors.create!(name: 'Phineas Tinkerton', email: 'ex@ample.com', phone: '123-456-7890')
      post "/api/v1/users/#{user.id}/email", params: 
      {
          user_url: "http://localhost:3000/#{user.id}/memorial"
      }

      email = UserMailer.send_email(user, user_url)

      expect(email.subject).to eq("Our Condolences")
      expect(email.to[0]).to eq 'Cousinbobby@test.com'
      expect(email.from[0]).to eq("elegy.notify@gmail.com")
      expect(email.body.raw_source).to include("Sorry to inform you, Cousin bobby")
      expect(email.body.raw_source).to include(user_url)
      expect(email.body.raw_source).to include("#{user.name} has passed away. #{user.name} cared for you very much, and wanted to show you how they would like to be remembered.")
      expect(email.body.raw_source).to include("#{user.name} designated Phineas Tinkerton as the executor of this memorial page, if you have any questions you can contact Phineas Tinkerton at 123-456-7890 or ex@ample.com")
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
