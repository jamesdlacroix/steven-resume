require "boarding_pass"
require "lib/application_helper"
helpers ApplicationHelper

page "/sitemap.xml", :layout => false

activate :deploy do |deploy|
  deploy.method = :git
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :fonts_dir, 'fonts'

# Build-specific configuration
configure :build do
  activate :minify_css, :ignore => [%r{fonts}]
  activate :minify_javascript
  activate :minify_html
  activate :gzip
  activate :asset_hash, :ignore => [%r{^fonts/89305}]

  # TODO necessary?
  compass_config do |config|
    config.sass_options = { :debug_info => false }
  end
end
