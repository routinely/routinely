module ApplicationHelper
  def webpack_asset_path(bundle, kind = "js")
    webpack_assets = File.read(Rails.root.join("webpack-assets.json"))
    JSON.parse(webpack_assets)[bundle][kind]
  end
end
