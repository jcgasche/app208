module CompaniesHelper


		def companies_to_load?( page, last_page, limit)

			unless limit.nil?
				unless (page <= last_page && Company.all.count < limit.to_i)
					return true
				else
					return false
				end
			end

		end


end
