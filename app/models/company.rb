class Company < ActiveRecord::Base

	has_many :relationships, dependent: :destroy
	has_many :users, through: :relationships, source: :user, class_name: "User" 


	def investor_followers
		users.where("(investor = ? AND following = ?)", true, true)
	end

	def followers
		users.where("(following = ?)", true)
	end


end
