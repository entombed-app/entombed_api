require 'rails_helper'

RSpec.describe Executor do
  describe 'relationships' do
    it { should belong_to(:user) }
  end
end