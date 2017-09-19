# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( analysis.js )
Rails.application.config.assets.precompile += %w( docket.js )
Rails.application.config.assets.precompile += %w( menu.js )
Rails.application.config.assets.precompile += %w( vahs.js )
Rails.application.config.assets.precompile += %w( fiscalyear.js )
Rails.application.config.assets.precompile += %w( reports.js )
Rails.application.config.assets.precompile += %w( reports.tab.js )
Rails.application.config.assets.precompile += %w( modify-employee.js )
Rails.application.config.assets.precompile += %w( applicant-new-search.js )

Rails.application.config.assets.precompile += %w( menu.scss )
Rails.application.config.assets.precompile += %w( vahs.scss )
Rails.application.config.assets.precompile += %w( fiscalyear.scss )
Rails.application.config.assets.precompile += %w( hr.scss )
Rails.application.config.assets.precompile += %w( reports.scss )
Rails.application.config.assets.precompile += %w( employee-search.css )
