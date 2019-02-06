class ProductsUpdateJob < ApplicationJob
  # def perform(shop_domain:, webhook:)
  #   shop = Shop.find_by(shopify_domain: shop_domain)

  #   shop.with_shopify_session do
  #     p "____________CreateJob___________________"
  #   end
  # end
  queue_as :default
  require 'sidekiq/api'

  def perform(*params)
    p "______________ProductsUpdate______________"
    # authenticate api
    session_api(params.first[:shop_domain])

    # get PRoduct info from shopify
    @p_id = params.first[:webhook][:id]
    p "_____________size"
    p ShopifyAPI::Product.find(:all).select{ |p| p.id == @p_id}.size
    # handling update by delete
    if ShopifyAPI::Product.find(:all, params: {limit: 250}).select{|p| p.id == @p_id}.size > 0
      @shopify_product = ShopifyAPI::Product.find(@p_id)

      # if the product has a deadline set
      # TODO : Check if any change (now jobs are set every update)
      unless @shopify_product.metafields.select { |meta| meta.attributes["key"] == "deadline"}.empty?
        deadline(params)
      else
        Sidekiq::ScheduledSet.new.each do |jobi|
          delete_previous_job(jobi)
        end
      end


    else
    p "______________Product Don't Exists anymore______________"

      # product just get delete
    end
    p "______________end perform______________"

  end

  def deadline(params)
    p "______________Deadline______________"

    # get the deadline and transform to DateTime
    @deadline = @shopify_product.metafields.select { |meta| meta.attributes["key"] == "deadline"}.first.value
    @date_dead_line = Time.parse(@deadline)
    # @date_dead_line = Time.now + 50

    # if there is an unpublish job for this product, cancel it
    Sidekiq::ScheduledSet.new.each do |jobi|
      delete_previous_job(jobi)
    end

    Sidekiq::ScheduledSet.new.each do |jobi|
      p jobi.jid
    end
    # if it an update, cancel previous job and set it a new one.
    UnpublishProductJob.set(wait_until: @date_dead_line).perform_later(params.first)
    p "______________Deadline - end______________"

  end


  def delete_previous_job(jobi)
    @job = Sidekiq::ScheduledSet.new.find_job(jobi.jid)
    if job_class? && product_id?
      p "________________jobdelete______________"
      @job.delete
    end
  end

  def job_class?
    @job.args.first["job_class"] == "UnpublishProductJob"
  end

  def product_id?
    @job.args.first["arguments"].first["webhook"]["id"] == @p_id
  end

end
