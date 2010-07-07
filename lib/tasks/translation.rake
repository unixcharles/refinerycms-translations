namespace :refinery do
  namespace :translation do
	  desc "Install translation plugin"
 
  	task :install do
  		puts `ruby #{File.expand_path(File.dirname(__FILE__) << '/../..')}/bin/refinerycms-translation-install #{Rails.root.to_s}`
  	end
	end
end