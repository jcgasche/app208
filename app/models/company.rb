class Company < ActiveRecord::Base

	has_many :relationships, dependent: :destroy
	has_many :viewers, through: :relationships, source: :user_id, class_name: "User" 


	def investor_followers
		viewers.where("(investor = ? AND following = ?)", true, true)
	end

	def followers
		viewers.where("(following = ?)", true)
	end


end
