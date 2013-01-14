require 'rubygems'
require 'fileutils'
require 'tmpdir'
require 'sinatra'
require File.expand_path('../lib/sprite_factory', File.dirname(__FILE__))

set :public_folder, File.dirname(__FILE__) + '/view'

get '/' do
	File.read(File.dirname(__FILE__) + '/view/index.html')
end

post '/' do
	tmp_dir = Dir.mktmpdir

	params[:images].each do|img|
		File.open(tmp_dir + '/' + img[:filename], "w") do |f|
			f.write(img[:tempfile].read)
		end
	end

	SpriteFactory.run!(tmp_dir,{
		:layout => params[:layout] || :diagonal,
		:margin => params[:margin].to_i || 0,

		:selector => '.sprite-',
		:output_image => tmp_dir + '/sprite.png',
		:output_style => tmp_dir + '/sprite.css',

		:library => :chunkypng,
		:pngcrush => true
	})

	system("cd #{tmp_dir} && zip sprite.zip sprite.png sprite.css")

	redirect "/download?dir=#{tmp_dir}&file=#{tmp_dir}/sprite.zip"
end

after '/download' do 
	Thread.new do
		sleep 20
		FileUtils.rm_rf("#{params[:dir]}")
		puts "rm -rf #{params[:dir]}"
	end
end

get '/download' do 
	send_file "#{params[:file]}", :filename => 'sprite.zip', :type => 'Application/octet-stream'
end