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

	def info
		{ 	name: self.name, 
			id: self.id, 
			logo_url: self.logo_url, 
			product_desc: self.product_desc,
			high_concept: self.high_concept,
			markets: self.markets,
			location: self.location,
			raising_amount: self.raising_amount,
			pre_money_valuation: self.pre_money_valuation,
			raised_amount: self.raised_amount,
			website_url: self.url,
			users_following: self.followers.count,
			total_views: self.users.count
		}
	end




end


