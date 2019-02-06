class UnpublishProductJob < ApplicationJob
  queue_as :default

  def perform(*params)

    p "___________UnpublishProduct___________"
    # authenticate api
    session_api(params.first[:shop_domain])
    if ShopifyAPI::Product.find(:all, params: {limit: 250}).select{|p| p.id == params.first[:webhook][:id]}.size > 0
      # unpublish product
      @shopify_product = ShopifyAPI::Product.find(params.first[:webhook][:id])
      @shopify_product.published_at = nil
      @shopify_product.save
    end
  end
end




