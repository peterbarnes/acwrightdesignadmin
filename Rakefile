require File.dirname(__FILE__) + '/bootstrap.rb'

namespace :compass do
  desc "Watch the stylesheets dir for changes"
  task :watch do
    sh("compass watch --sass-dir #{Dir.pwd}/stylesheets --css-dir #{Dir.pwd}/public/stylesheets -s compressed")
  end
  
  desc "Compile the stylesheets"
  task :compile do
    sh("compass compile --sass-dir #{Dir.pwd}/stylesheets --css-dir #{Dir.pwd}/public/stylesheets -s compressed")
  end
end

namespace :acwrightdesignadmin do
  desc "Start the console"
  task :console do
    sh("irb -r #{Dir.pwd}/bootstrap.rb")
  end
end