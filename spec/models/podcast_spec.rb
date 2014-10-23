require 'rails_helper'

RSpec.describe Podcast, :type => :model do
  it 'is not valid without url' do
    expect(build(:podcast, url: nil)).to_not be_valid
  end

  it 'is not valid with wrong url' do
    expect(build(:podcast, url: 'http:fakeurl')).to_not be_valid
  end

  it 'is not valid when url is less than 9 characters' do
    expect(build(:podcast, url: 'http://a')).to_not be_valid
  end
end
