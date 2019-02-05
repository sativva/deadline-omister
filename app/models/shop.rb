  class Shop < ActiveRecord::Base
    include ShopifyApp::SessionStorage

    def connect_to_store
      session = ShopifyAPI::Session.new(self.shopify_domain, self.shopify_token)
      session.valid?
      ShopifyAPI::Base.activate_session(session)
    end
  end

