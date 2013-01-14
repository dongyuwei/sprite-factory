$: << '../../lib'
require 'rubygems'
require 'sprite_factory.rb'

SpriteFactory.run!('../images/regular',{
	:layout => :diagonal,
	:margin => 10,

	:selector => '.sprite-',
	:output_image => '/tmp/sprite.png',
	:output_style => '/tmp/sprite.css',
	
	:pngcrush => true
})
