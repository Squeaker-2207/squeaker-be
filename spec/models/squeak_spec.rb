require 'rails_helper'

RSpec.describe Squeak, type: :model do
  describe 'validations' do
    it { should belong_to :user }
  end
end
