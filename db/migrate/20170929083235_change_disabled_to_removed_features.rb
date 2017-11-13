class ChangeDisabledToRemovedFeatures < ActiveRecord::Migration[5.1]
  def change
  	Feature.where("status = 'disabled'").update_all(status: 'removed')
  end
end
