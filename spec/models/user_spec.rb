require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    
    describe 'uniqueness' do
      subject { User.new(name: 'Joe', email: 'joe@shmoe.com') }
      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end
end