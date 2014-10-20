class CompaniesController < ApplicationController
	include CompaniesHelper

	def fill_db

		page = 1
		limit = nil unless limit = params[:limit].to_i

		loop do

			# Get companies raising - from AngelCo API
			url = URI.parse("http://api.angel.co/1/startups?filter=raising&page=#{page}")
			req = Net::HTTP::Get.new(url.to_s)
			response = Net::HTTP.start(url.host, url.port) {|http|
				http.request(req)
			}

			# Response hash contains startup info (id, name, fundraising),
			response_hash = JSON.parse response.body

			companies = response_hash['startups']
			page = response_hash['page'].to_i + 1
			last_page = response_hash['last_page']

			puts "_____________________________"
			puts "_____________________________"
			puts "_____________________________"
			puts "_____________________________"
			puts "page: " << page.to_s
			puts "total: " << last_page.to_s
			puts "number of cs: " << Company.count.to_s

			# Take each company individually and create company in database 
			companies.each do |company| 
				break if Company.count >= limit

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

			break unless companies_to_load?( page, last_page, limit)
		end 

		redirect_to companies_path
	end


	def index
		@companies = Company.all.paginate(page: params[:page], :per_page => 10)
	end




	




end
