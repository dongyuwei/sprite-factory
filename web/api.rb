require 'rubygems'
require 'fileutils'
require 'sinatra'

$: << '../lib'
require 'sprite_factory.rb'

set :public_folder, File.dirname(__FILE__) + '/view'

get '/' do
	File.read(File.dirname(__FILE__) + '/view/index.html')
end

post '/' do
	FileUtils.rm_rf('/tmp/_sprite_/')
	FileUtils.mkdir_p('/tmp/_sprite_/')

	params[:images].each do|img|
		File.open('/tmp/_sprite_/' + img[:filename], "w") do |f|
			f.write(img[:tempfile].read)
		end
	end
	puts  params[:layout],params[:margin].to_i,params[:margin].to_i || 0
	SpriteFactory.run!('/tmp/_sprite_/',{
		:layout => params[:layout] || :diagonal,
		:margin => params[:margin].to_i || 0,

		:selector => '.sprite-',
		:output_image => '/tmp/sprite.png',
		:output_style => '/tmp/sprite.css',

		# :library => :chunkypng,
		:pngcrush => true
	})

	FileUtils.rm_rf('/tmp/_sprite_/')
	FileUtils.mkdir_p('/tmp/_sprite_/')

	FileUtils.mv('/tmp/sprite.png','/tmp/_sprite_/sprite.png')
	FileUtils.mv('/tmp/sprite.css','/tmp/_sprite_/sprite.css')

	FileUtils.rm_rf('/tmp/sprite.zip')

	system('cd /tmp/_sprite_/ && zip -r sprite.zip ./* ')

	redirect '/download/sprite.zip'
end

get '/download/sprite.zip' do 
	send_file "/tmp/_sprite_/sprite.zip", :filename => 'sprite.zip', :type => 'Application/octet-stream'

	FileUtils.rm_rf('/tmp/_sprite_/')
end