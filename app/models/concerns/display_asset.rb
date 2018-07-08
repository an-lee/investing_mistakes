module DisplayAsset
  extend ActiveSupport::Concern

  class_methods do
    def asset_methods(*methods, precision: 8)
      methods.each do |asset_method|
        define_method("display_#{asset_method}") do
          asset = public_send(asset_method)
          asset.nil? ? '' : format(format('%%.%if', precision), asset.round(precision))
        end
      end
    end
  end
end
