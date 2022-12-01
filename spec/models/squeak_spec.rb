require 'rails_helper'

RSpec.describe Squeak, type: :model do
  describe 'validations' do
    it { should should belong_to :user }
  end
end
