class Company < ActiveRecord::Base

	has_many :relationships, dependent: :destroy
	has_many :users, through: :relationships, source: :user, class_name: "User" 


	def investor_followers
		users.where("(investor = ? AND following = ?)", true, true)
	end

	def followers
		users.where("(following = ?)", true)
	end


	def like_percentage
		if self.users.count > 0
			return (self.followers.count.to_f / self.users.count.to_f * 100 ).to_f.round()
		else 
			return 0
		end
	end

end
