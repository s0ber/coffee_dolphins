BOWER_DIRS = ['.']
COMPONENTS_PATH = 'vendor/assets/components'

namespace :bower do
  task :install do
    require 'colorize'

    if `which node`.blank?
      puts 'You need to install Node.js before continue (`brew upgrade && brew install node`)'.red
      exit 1

    elsif `which bower`.blank?
      puts 'You need to install bower before continue (http://bower.io/#installing-bower)'.red
      exit 1

    else
      puts 'Attempt to install bower packages'.yellow
      BOWER_DIRS.each do |dir|
        bower_dir = Rails.root.join(dir)
        components_dir = File.join(bower_dir, COMPONENTS_PATH)
        puts "Installing packages for #{bower_dir}".yellow
        sh "rm -rf #{components_dir}"
        sh "cd #{bower_dir} && bower install --config.interactive=false"
        puts 'Done'.green
      end
      puts 'All bower packages are installed'.green
    end
  end
end
