require 'spec_helper'

RSpec.describe Permission, type: :model do

  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:permission).valid?).to be true
      expect(FactoryGirl.build(:create_permission).valid?).to be true
      expect(FactoryGirl.build(:update_permission).valid?).to be true
      expect(FactoryGirl.build(:delete_permission).valid?).to be true
      expect(FactoryGirl.build(:all_permission).valid?).to be true
    end

    it "should set correct permissions" do
      expect(FactoryGirl.build(:permission).can_create).to be_falsy
      expect(FactoryGirl.build(:permission).can_read).to be_truthy
      expect(FactoryGirl.build(:permission).can_update).to be_falsy
      expect(FactoryGirl.build(:permission).can_delete).to be_falsy

      expect(FactoryGirl.build(:create_permission).can_create).to be_truthy
      expect(FactoryGirl.build(:create_permission).can_read).to be_truthy
      expect(FactoryGirl.build(:create_permission).can_update).to be_falsy
      expect(FactoryGirl.build(:create_permission).can_delete).to be_falsy

      expect(FactoryGirl.build(:update_permission).can_create).to be_falsy
      expect(FactoryGirl.build(:update_permission).can_read).to be_truthy
      expect(FactoryGirl.build(:update_permission).can_update).to be_truthy
      expect(FactoryGirl.build(:update_permission).can_delete).to be_falsy

      expect(FactoryGirl.build(:delete_permission).can_create).to be_falsy
      expect(FactoryGirl.build(:delete_permission).can_read).to be_truthy
      expect(FactoryGirl.build(:delete_permission).can_update).to be_falsy
      expect(FactoryGirl.build(:delete_permission).can_delete).to be_truthy

      expect(FactoryGirl.build(:all_permission).can_create).to be_truthy
      expect(FactoryGirl.build(:all_permission).can_read).to be_truthy
      expect(FactoryGirl.build(:all_permission).can_update).to be_truthy
      expect(FactoryGirl.build(:all_permission).can_delete).to be_truthy
    end
  end

  context "Validations" do
    it { should allow_value(true).for(:can_create )}
    it { should allow_value(false).for(:can_create )}
    it { should_not allow_value("").for(:can_create )}

    it { should allow_value(true).for(:can_read )}
    it { should allow_value(false).for(:can_read )}
    it { should_not allow_value("").for(:can_read )}

    it { should allow_value(true).for(:can_update )}
    it { should allow_value(false).for(:can_update )}
    it { should_not allow_value("").for(:can_update )}

    it { should allow_value(true).for(:can_delete )}
    it { should allow_value(false).for(:can_delete )}
    it { should_not allow_value("").for(:can_delete )}
  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:feature) }
  end

end