class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]

  def home
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end
end
