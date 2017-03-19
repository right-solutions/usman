class AddStatus < ActiveRecord::Migration[5.0]
  def change
  	add_column :features, :status, :string, :null => false, :default=>"unpublished", :limit=>16
  end
end
