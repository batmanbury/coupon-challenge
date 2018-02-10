module ApplicationHelper
  def asset_exists?(path)
    if Rails.configuration.assets.compile
      # in development, when there is no static manifest file
      Rails.application.precompiled_assets.include? path
    else
      # in production
      Rails.application.assets_manifest.assets[path].present?
    end
  end
end
