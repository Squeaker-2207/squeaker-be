require 'rails_helper'

RSpec.describe Squeak, type: :model do
  describe 'validations' do
    it { should belong_to :user }
    it { should validate_presence_of :content }


  end
end
