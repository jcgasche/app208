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

			location = company['locations'].first['display_name'] unless company['locations'].empty?
			raising = company['fundraising']['raising_amount'] unless company['fundraising'].empty?
			valuation = company['fundraising']['pre_money_valuation'] unless company['fundraising'].empty?
			raised = company['fundraising']['raised_amount'] unless company['fundraising'].empty?


			if Company.find_by(angel_id: company['id'])

				Company.find_by(angel_id: company['id']).update_attributes(
					name: company['name'], 
					logo_url: company['logo_url'], product_desc: company['product_desc'], 
					high_concept: company['high_concept'], markets: markets,
					raising_amount: raising, 
					pre_money_valuation: valuation,
					raised_amount: raised,
					location: location,
					url: company['company_url']
					)
				
			else

				Company.new( angel_id: company['id'], 
					name: company['name'], 
					logo_url: company['logo_url'], product_desc: company['product_desc'], 
					high_concept: company['high_concept'], markets: markets,
					raising_amount: raising, 
					pre_money_valuation: valuation,
					raised_amount: raised,
					location: location,
					url: company['company_url']
					).save!
			end
		end
		render xml: Company.all
	end

end
