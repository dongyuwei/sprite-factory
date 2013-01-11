module SpriteFactory
	module Layout
		# **diagonal layout** : from `bottom-left` to `top-right`
		module Diagonal
			def self.layout(images, options = {})
				hmargin    = options[:hmargin]  || 0
				vmargin    = options[:vmargin]  || 0

				total_width  = (images.length + 1) * hmargin + images.inject(0) {|sum, img| sum + img[:width]}
				total_height = (images.length + 1) * vmargin + images.inject(0) {|sum, img| sum + img[:height]}

				previous = nil
				images.each do |image|
					if previous.nil?
						previous = image
						image[:y] = total_height - image[:height] - vmargin
						image[:x] = 0 + hmargin

						image[:cssw] = image[:width]
						image[:cssh] = image[:height]

						image[:cssx] = image[:x]
						image[:cssy] = image[:y]

						next
					end
					image[:y] = previous[:y] - image[:height] - vmargin 
					image[:x] = previous[:x] + previous[:width] + hmargin
					
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
