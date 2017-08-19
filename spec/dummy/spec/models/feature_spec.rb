require 'spec_helper'

RSpec.describe Feature, type: :model do

  let(:feature) {FactoryGirl.build(:feature)}

  let(:published_feature) {FactoryGirl.build(:published_feature)}
  let(:unpublished_feature) {FactoryGirl.build(:unpublished_feature)}
  let(:disabled_feature) {FactoryGirl.build(:disabled_feature)}

  let(:photo_gallery) {FactoryGirl.create(:published_feature, name: "Photo Gallery")}
  let(:video_gallery) {FactoryGirl.create(:published_feature, name: "Video Gallery")}
  let(:brands) {FactoryGirl.create(:published_feature, name: "Brands")}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:feature).valid?).to be true
      
      published_feature = FactoryGirl.build(:published_feature)
      expect(published_feature.status).to match("published")
      expect(published_feature.valid?).to be true

      unpublished_feature = FactoryGirl.build(:unpublished_feature)
      expect(unpublished_feature.status).to match("unpublished")
      expect(unpublished_feature.valid?).to be true

      disabled_feature = FactoryGirl.build(:disabled_feature)
      expect(disabled_feature.status).to match("disabled")
      expect(disabled_feature.valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('New Name').for(:name )}
    it { should_not allow_value('AB').for(:name )}
    it { should_not allow_value("x"*257).for(:name )}

    it { should validate_inclusion_of(:status).in_array(Feature::STATUS.keys)  }
  end

  context "Associations" do
    it { should have_many(:users) }
    it { should have_many(:permissions) }
    it { should have_one(:feature_image) }
  end

  context "Class Methods" do
    it "search" do
      arr = [photo_gallery, video_gallery, brands]
      expect(Feature.search("Photo Gallery")).to match_array([photo_gallery])
      expect(Feature.search("Video Gallery")).to match_array([video_gallery])
      expect(Feature.search("Brands")).to match_array([brands])
      expect(Feature.search("Gallery")).to match_array([photo_gallery, video_gallery])
    end

    it "scope published" do
      arr = [photo_gallery, video_gallery, brands]
      expect(Feature.published.all).to match_array [photo_gallery, video_gallery, brands]
    end

    it "scope unpublished" do
      arr = [photo_gallery, video_gallery, brands]
      unpublished_feature = FactoryGirl.create(:unpublished_feature)
      expect(Feature.unpublished.all).to match_array [unpublished_feature]
    end

    it "scope disabled" do
      arr = [photo_gallery, video_gallery, brands]
      disabled_feature = FactoryGirl.create(:disabled_feature)
      expect(Feature.disabled.all).to match_array [disabled_feature]
    end

    context "Import Methods" do
      it "save_row_data" do
        skip "To Be Implemented"
      end
    end
  end

  context "Instance Methods" do

    context "Status Methods" do
      it "publish!" do
        u = FactoryGirl.create(:unpublished_feature)
        u.publish!
        expect(u.status).to match "published"
        expect(u.published?).to be_truthy
      end

      it "unpublish!" do
        u = FactoryGirl.create(:unpublished_feature)
        u.unpublish!
        expect(u.status).to match "unpublish"
        expect(u.unpublished?).to be_truthy
      end

      it "disable!" do
        u = FactoryGirl.create(:disabled_feature)
        u.disable!
        expect(u.status).to match "disabled"
        expect(u.disabled?).to be_truthy
      end
    end

    context "Permission Methods" do
      it "can_be_edited?" do
        expect(published_feature.can_be_edited?).to be_truthy
        expect(unpublished_feature.can_be_edited?).to be_truthy
        expect(disabled_feature.can_be_edited?).to be_falsy
      end

      it "can_be_deleted?" do
        expect(published_feature.can_be_deleted?).to be_truthy
        expect(unpublished_feature.can_be_deleted?).to be_truthy
        expect(disabled_feature.can_be_deleted?).to be_truthy
      end

      it "can_be_published?" do
        expect(published_feature.can_be_published?).to be_falsy
        expect(unpublished_feature.can_be_published?).to be_truthy
        expect(disabled_feature.can_be_published?).to be_truthy
      end

      it "can_be_unpublished?" do
        expect(published_feature.can_be_unpublished?).to be_truthy
        expect(unpublished_feature.can_be_unpublished?).to be_falsy
        expect(disabled_feature.can_be_unpublished?).to be_truthy
      end

      it "can_be_disabled?" do
        expect(published_feature.can_be_disabled?).to be_truthy
        expect(unpublished_feature.can_be_disabled?).to be_truthy
        expect(disabled_feature.can_be_disabled?).to be_falsy
      end
    end

    context "Other Methods" do
      it "display_name" do
        expect(brands.display_name).to match("Brands")
      end
    end

  end

end