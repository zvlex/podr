require 'rails_helper'

RSpec.describe Category, :type => :model do
    it 'is valid with a title and description' do
      expect(build(:category)).to be_valid
    end

    it 'is not valid without title' do
      expect(build(:category, title: nil)).to_not be_valid
    end

    it 'is not valid without description' do
      expect(build(:category, description: nil)).to_not be_valid
    end
end
