require 'spec_helper'

RSpec.describe Feature, type: :model do

  let(:feature) {FactoryBot.build(:feature)}

  let(:published_feature) {FactoryBot.build(:published_feature)}
  let(:unpublished_feature) {FactoryBot.build(:unpublished_feature)}
  let(:removed_feature) {FactoryBot.build(:removed_feature)}

  let(:photo_gallery) {FactoryBot.create(:published_feature, name: "Photo Gallery")}
  let(:video_gallery) {FactoryBot.create(:published_feature, name: "Video Gallery")}
  let(:brands) {FactoryBot.create(:published_feature, name: "Brands")}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryBot.build(:feature).valid?).to be_truthy
      
      published_feature = FactoryBot.build(:published_feature)
      expect(published_feature.status).to match("published")
      expect(published_feature.valid?).to be_truthy

      unpublished_feature = FactoryBot.build(:unpublished_feature)
      expect(unpublished_feature.status).to match("unpublished")
      expect(unpublished_feature.valid?).to be_truthy

      removed_feature = FactoryBot.build(:removed_feature)
      expect(removed_feature.status).to match("removed")
      expect(removed_feature.valid?).to be_truthy
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('New Name').for(:name )}
    it { should_not allow_value('AB').for(:name )}
    it { should_not allow_value("x"*257).for(:name )}

    it { should validate_inclusion_of(:status).in_array(Feature::STATUS_REVERSE.keys)  }
  end

  context "Associations" do
    it { should have_many(:users) }
    it { should have_many(:permissions) }
    # it { should have_one(:feature_image) }
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
      unpublished_feature = FactoryBot.create(:unpublished_feature)
      expect(Feature.unpublished.all).to match_array [unpublished_feature]
    end

    it "scope removed" do
      arr = [photo_gallery, video_gallery, brands]
      removed_feature = FactoryBot.create(:removed_feature)
      expect(Feature.removed.all).to match_array [removed_feature]
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
        u = FactoryBot.create(:unpublished_feature)
        u.publish!
        expect(u.status).to match "published"
        expect(u.published?).to be_truthy
      end

      it "unpublish!" do
        u = FactoryBot.create(:published_feature)
        u.unpublish!
        expect(u.status).to match "unpublish"
        expect(u.unpublished?).to be_truthy
      end

      it "remove!" do
        u = FactoryBot.create(:unpublished_feature)
        u.remove!
        expect(u.status).to match "removed"
        expect(u.removed?).to be_truthy
      end
    end

    context "Permission Methods" do
      it "can_be_edited?" do
        expect(published_feature.can_be_edited?).to be_truthy
        expect(unpublished_feature.can_be_edited?).to be_truthy
        expect(removed_feature.can_be_edited?).to be_falsy
      end

      it "can_be_deleted?" do
        expect(published_feature.can_be_deleted?).to be_truthy
        expect(unpublished_feature.can_be_deleted?).to be_truthy
        expect(removed_feature.can_be_deleted?).to be_truthy
      end
    end

    context "Other Methods" do
      it "display_name" do
        expect(brands.display_name).to match("Brands")
      end
    end

  end

end