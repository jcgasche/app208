class StaticPagesController < ApplicationController


	def privacy
	end

	def home

		if Company.all.any?
			@best_startups = Company.all.sort_by {|obj| obj.like_percentage}
			@best_startups = @best_startups.reverse[0..3]

			@random_startups = Company.all.sample(15)
			@markets = []

			market_list = []
			@random_startups.each do |comp|
				comp.markets.split(%r{,\s*}).each do |market|
					market_list.push(market) 
				end
			end

			
			ordered_markets = market_list.each_with_object(Hash.new(0)){ |m,h| h[m] += 1 }.sort_by{ |k,v| v }
			ordered_markets.reverse!

			for index in 0 .. ordered_markets.size
				puts market_list[index].to_s << "  " << ordered_markets[index].to_s
			end

			for index in 0 .. 3
				@markets[index] = ordered_markets[index].first
			end
		else
			@best_startups = []
			@random_startups = []
			@markets = []
				
		end

	end


end
