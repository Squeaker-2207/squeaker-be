require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do 
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:username).ignoring_case_sensitivity }
    it { should have_many :squeaks}
  end

  describe 'instance methods' do
    describe '#follow' do
      it 'One user should be able to follow another user' do 
        users = create_list(:user, 2)
        expect(users[0].followers).to be_empty
        users[1].follow(users[0])
        expect(users[0].followers.include?(users[1])).to be(true)
      end
    end

    describe '#unfollow' do
      it 'A user should be able to unfollow another user' do 
        users = create_list(:user, 2)
        expect(users[0].followers).to be_empty
        users[1].follow(users[0])
        expect(users[0].followers.include?(users[1])).to be(true)

        users[1].unfollow(users[0])
        expect(users[0].followers).to be_empty
      end
    end
  end
end
