require 'rubygems'
require File.expand_path('../../lib/sprite_factory', File.dirname(__FILE__))

SpriteFactory.run!(File.expand_path('../images/regular', File.dirname(__FILE__)),{
	:layout => :diagonal,
	:margin => 10,

	:selector => '.sprite-',
	:output_image => '/tmp/sprite.png',
	:output_style => '/tmp/sprite.css',
	
	:pngcrush => true
})
