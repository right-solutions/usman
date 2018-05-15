class AddFeatureCategoryToFeatures < ActiveRecord::Migration[5.1]
  def change
  	add_column :features, :feature_category, :string, :null => false, :limit=>64, default: "Default"
  	Feature.update_all("feature_category = 'Default'")
  	
  	Feature.where("").update_all("feature_category = 'Default'")
  	
  	Feature.where("name like '%Dhatu%'").update_all("feature_category = 'Website Features'")
  	
  	Feature.where("name like '%Promotion%'").update_all("feature_category = 'Marketing Features'")
  	Feature.where("name like '%Offer%'").update_all("feature_category = 'Marketing Features'")
  	Feature.where("name like '%Booking%'").update_all("feature_category = 'Marketing Features'")
  	Feature.where("name like '%Blog%'").update_all("feature_category = 'Marketing Features'")

  	Feature.where("name like '%User%'").update_all("feature_category = 'Admin'")
  	Feature.where("name like '%Role%'").update_all("feature_category = 'Admin'")
  	Feature.where("name like '%Permission%'").update_all("feature_category = 'Admin'")
  	Feature.where("name like '%Feature%'").update_all("feature_category = 'Admin'")
  	Feature.where("name like '%Country%' or name like '%Countries%'").update_all("feature_category = 'Admin'")
  	Feature.where("name like '%Region%'").update_all("feature_category = 'Admin'")
  	Feature.where("name like '%City%' or name like '%Cities%'").update_all("feature_category = 'Admin'")
  end
end
