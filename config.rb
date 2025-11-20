# Unique header generation
require './lib/unique_head.rb'

# Markdown
set :markdown_engine, :redcarpet
set :markdown,
    fenced_code_blocks: true,
    smartypants: true,
    disable_indented_code_blocks: true,
    prettify: true,
    strikethrough: true,
    tables: true,
    with_toc_data: true,
    no_intra_emphasis: true,
    renderer: UniqueHeadCounter

# Assets
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :fonts_dir, 'fonts'

# Activate the syntax highlighter
activate :syntax
ready do
  require './lib/monokai_sublime_slate.rb'
  require './lib/multilang.rb'
end

activate :sprockets

activate :autoprefixer do |config|
  config.browsers = ['last 2 version', 'Firefox ESR']
  config.cascade  = false
  config.inline   = true
end

# Github pages require relative links
activate :relative_assets
set :relative_links, true

# Build Configuration
configure :build do
  # We do want to hash woff and woff2 as there's a bug where woff2 will use
  # woff asset hash which breaks things. Trying to use a combination of ignore and
  # rewrite_ignore does not work as it conflicts weirdly with relative_assets. Disabling
  # the .woff2 extension only does not work as .woff will still activate it so have to
  # have both. See https://github.com/slatedocs/slate/issues/1171 for more details.
  activate :asset_hash, :exts => app.config[:asset_extensions] - %w[.woff .woff2 .json]
  # If you're having trouble with Middleman hanging, commenting
  # out the following two lines has been known to help
  activate :minify_css
  # Don't minify service worker or manifest
  activate :minify_javascript, ignore: ['service-worker.js', 'manifest.json']
  # activate :gzip
end

# Ignore patterns for build - don't process service worker through asset pipeline
ignore /service-worker\.js/

# Copy service worker without processing
after_build do |builder|
  # Copy service worker from project root
  src = File.expand_path('../../service-worker.js', __FILE__)
  dst = File.join(app.config[:build_dir], 'service-worker.js')
  if File.exist?(src)
    FileUtils.cp(src, dst)
    builder.say_status :create, 'service-worker.js', :green
  end
end

# Deploy Configuration
# If you want Middleman to listen on a different port, you can set that below
set :port, 4567

helpers do
  require './lib/toc_data.rb'
end
