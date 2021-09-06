require 'rails_helper'

RSpec.describe 'Email send' do
  describe 'email' do
    it 'can send emails to user recipients' do
      user = create(:user)
      user.profile_picture.attach(
            io: File.open('./public/profile_pictures/profile-picture.png'),
            filename: 'profile-picture.png',
            content_type: 'application/png'
        )
      user.recipients.create!(name: 'Uncle bobby', email: 'unclebobby@test.com')

      post "/api/v1/users/#{user.id}/email"

      email = UserMailer.send_email(user)

      expect(email.subject).to eq("Our Condolences")
      expect(email.to[0]).to eq("unclebobby@test.com")
      expect(email.from[0]).to eq("elegy.notify@gmail.com")
      expect(email.body).to include("Sorry to inform you, Uncle bobby")
    end

    it 'can send emails to multiple user recipients' do
      user = create(:user)
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

      post "/api/v1/users/#{user.id}/email"

      email = UserMailer.send_email(user)

      expect(email.subject).to eq("Our Condolences")
      expect(email.to[0]).to be_a(String)
      expect(email.from[0]).to be_a(String)
      expect(email.body).to include("Sorry to inform you,")
    end

    it 'will return an errorr if user not found' do
      expect {
        post "/api/v1/users/8000/email"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

    