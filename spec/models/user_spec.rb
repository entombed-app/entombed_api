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
end