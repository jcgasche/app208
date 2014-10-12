class CompaniesController < ApplicationController

	def fill_db

		# Get companies raising - from AngelCo API
		url = URI.parse("http://api.angel.co/1//startups?filter=raising")
		req = Net::HTTP::Get.new(url.to_s)
		response = Net::HTTP.start(url.host, url.port) {|http|
			http.request(req)
		}

		# Response hash contains startup info (id, name, fundraising),
		response_hash = JSON.parse response.body

		companies = response_hash['startups']

		# Take each company individually and create company in database 
		companies.each do |company| 
			markets = ""
			company['markets'].each do |market_tag|
				markets = markets << market_tag['display_name'] << ", "
			end
			markets = markets[0..-3]
			if Company.find_by(angel_id: company['id'])
				Company.find_by(angel_id: company['id']).update_attributes(angel_id: company['id'], name: company['name'], 
					logo_url: company['logo_url'], product_desc: company['product_desc'], 
					high_concept: company['high_concept'], markets: markets,
					raising_amount: company['fundraising']['raising_amount'], 
					pre_money_valuation: company['fundraising']['pre_money_valuation'])
				puts "8888888888"
				puts company['fundraising']['raising_amount']
				puts company['fundraising']['pre_money_valuation']
				
			else
				Company.new( angel_id: company['id'], name: company['name'], 
					logo_url: company['logo_url'], product_desc: company['product_desc'], 
					high_concept: company['high_concept'], markets: markets,
					raising_amount: company['fundraising']['raising_amount'], 
					pre_money_valuation: company['fundraising']['pre_money_valuation'] ).save!
			end
		end
		render xml: Company.all
	end

end
