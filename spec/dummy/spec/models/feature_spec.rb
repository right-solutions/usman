require 'spec_helper'

RSpec.describe Feature, type: :model do

  let(:feature) {FactoryGirl.build(:feature)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:feature).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('New Name').for(:name )}
    it { should_not allow_value('AB').for(:name )}
    it { should_not allow_value("x"*257).for(:name )}
  end

  context "Associations" do
    it { should have_many(:users) }
    it { should have_many(:permissions) }
  end

end