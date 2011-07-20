require 'rake'
require 'rake/testtask'


$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

desc "release and build and push new website"
task :push => [:release, :web]

desc "build and push website"
task :web => :build_webpage do
  puts "Building and pushing website"
  Dir.chdir "../project-webpages" do
    `scp out/hush.html zoe2@instantwatcher.com:~/danielchoi.com/public/software/`
    #`rsync -avz out/images-hush zoe2@instantwatcher.com:~/danielchoi.com/public/software/`
    #`rsync -avz out/stylesheets zoe2@instantwatcher.com:~/danielchoi.com/public/software/`
    #`rsync -avz out/lightbox2 zoe2@instantwatcher.com:~/danielchoi.com/public/software/`
  end
  #`open http://danielchoi.com/software/hush.html`
end

desc "build webpage"
task :build_webpage do
  `cp README.markdown ../project-webpages/src/hush.README.markdown`
  `cp coverage.markdown ../project-webpages/src/hush.coverage.markdown`
  Dir.chdir "../project-webpages" do
    puts `ruby gen.rb hush `
    `open out/hush.html`
  end
end


