# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w(clike.js)
Rails.application.config.assets.precompile += %w(codemirror.js)
Rails.application.config.assets.precompile += %w(matchbrackets.js)
Rails.application.config.assets.precompile += %w(show-hint.js)
Rails.application.config.assets.precompile += %w(bootstrap-modal-popover.js)
Rails.application.config.assets.precompile += %w(jquery_videocontrols.js)
Rails.application.config.assets.precompile += %w(bootstrap-filestyle.min.js)
Rails.application.config.assets.precompile += %w(circle-progress.js)

Rails.application.config.assets.precompile += %w(dracula.css)
Rails.application.config.assets.precompile += %w(jquery_videocontrols.css)

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
