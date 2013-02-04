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

	file_name = (params[:filename].empty? ) ? 'sprite' : params[:filename]
	css_path = (params[:csspath].empty?) ? nil : params[:csspath]
	
	SpriteFactory.run!(tmp_dir,{
		:layout => params[:layout] || :diagonal,
		:margin => params[:margin].to_i || 5,
		:csspath => css_path,

		:selector => '.icon-',
		:output_image => tmp_dir + '/' + file_name + '.png',
		:output_style => tmp_dir + '/' + file_name + '.less',


		:library => :rmagick,
		:pngcrush => true
	})

	system("cd #{tmp_dir} && zip #{file_name}.zip #{file_name}.png #{file_name}.less")

	redirect "/download?dir=#{tmp_dir}&file=#{tmp_dir}/#{file_name}.zip"
end

after '/download' do 
	Thread.new do
		sleep 50
		FileUtils.rm_rf("#{params[:dir]}")
		puts "rm -rf #{params[:dir]}"
	end
end

get '/download' do 
	send_file "#{params[:file]}", :filename => 'sprite.zip', :type => 'Application/octet-stream'
end