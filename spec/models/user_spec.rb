require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do 
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:username).ignoring_case_sensitivity }
    it { should have_many :squeaks}
  end
end
