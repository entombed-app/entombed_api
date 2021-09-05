require 'rails_helper'

RSpec.describe User do
  before(:all) do
    create(:user)
  end
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:date_of_birth) }
  end

  describe 'relationships' do
    it { should have_many(:executors).dependent(:destroy) }
  end

 
  describe 'profile_picture_url' do
    it 'returns image url' do
      user = create(:user)

      user.profile_picture.attach(
        io: File.open('./public/profile_pictures/profile-picture.png'),
        filename: 'profile-picture.png',
        content_type: 'application/png'
      )

      expect(user.profile_picture_url).to be_a(String)
      expect(user.profile_picture.attached?).to be(true)     
    end

    describe 'profile_picture_url' do
      it 'returns nil if no image is attached' do
        user = create(:user)
  
        expect(user.profile_picture_url).to be nil  
      end
    end
  end
end