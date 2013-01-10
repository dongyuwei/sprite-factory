$: << '../../lib'
require 'rubygems'
require 'sprite_factory.rb'

SpriteFactory.run!('../images/regular',{
	:layout => :diagonal,

	:selector => '.sprite_',
	:output_image => '/tmp/sprite.png',
	:output_style => '/tmp/sprite.css',
	
	# :library => :chunkypng,
	# :pngcrush => true,

	# :margin => 1
})
