module CompaniesHelper


		def companies_to_load?( page, last_page, limit)

			unless limit.nil?
				return true unless page <= last_page && Company.all.count < limit
			end

		end


end
