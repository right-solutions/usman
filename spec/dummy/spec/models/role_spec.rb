require 'spec_helper'

RSpec.describe Role, type: :model do

  let(:role) {FactoryGirl.build(:role)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:role).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('New Name').for(:name )}
    it { should_not allow_value('AB').for(:name )}
    it { should_not allow_value("x"*251).for(:name )}
  end

  context "Associations" do
    it { should have_and_belong_to_many(:users) }
  end

end