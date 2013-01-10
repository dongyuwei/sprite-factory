module SpriteFactory
	module Layout
		# **diagonal layout** : from `bottom-left` to `top-right`
		module Diagonal
			def self.layout(images, options = {})
				total_width = images.inject(0) {|sum, img| sum + img[:width]}
				total_height = images.inject(0) {|sum, img| sum + img[:height]}

				previous = nil
				images.each do |image|
					if previous.nil?
						previous = image
						image[:y] = total_height - image[:height]
						image[:x] = 0

						image[:cssw] = image[:width]
						image[:cssh] = image[:height]

						image[:cssx] = image[:x]
						image[:cssy] = image[:y]

						next
					end
					image[:y] = previous[:y] - image[:height]
					image[:x] = previous[:x] + previous[:width]
					
					image[:cssw] = image[:width]
					image[:cssh] = image[:height]

					image[:cssx] = image[:x]
					image[:cssy] = image[:y]

					previous = image
				end

				{:width => total_width,:height => total_height}
			end
		end
	end
end
