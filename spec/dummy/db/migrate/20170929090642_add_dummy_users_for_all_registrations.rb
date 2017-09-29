class AddDummyUsersForAllRegistrations < ActiveRecord::Migration[5.1]
  def change
  	relation = Registration.where("user_id is NULL")
  	puts "Total Registrations which doesn't have user: #{relation.count}"
  	relation.all.each do |r|
  		r.user = User.new
      r.user.generate_dummy_data(r.id)
      r.user.save
  	end
  end
end
