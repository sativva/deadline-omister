  class ProductsCreateJob < ApplicationJob
    queue_as :default

    def perform(*params)

      session_api(params.first[:shop_domain])
      p "____________CreateJob___________________"
     # Do something later
    end
  end
