require 'delivery/client/delivery_query'
require 'delivery/responses/delivery_item_listing_response'
require 'delivery/responses/delivery_item_response'
require 'json'

module Delivery
  # Executes requests against the Kentico Cloud Delivery API.
  class DeliveryClient
    attr_accessor :use_preview

    def initialize(config)
      @project_id = config.fetch(:project_id)
      @preview_key = config.fetch(:preview_key, nil)
      @content_link_url_resolver = config.fetch(:content_link_url_resolver, nil)
      self.use_preview = !@preview_key.nil?
    end

    def items(query_parameters = [])
      q = DeliveryQuery.new project_id: @project_id,
                            qp: query_parameters,
                            content_link_url_resolver: @content_link_url_resolver
      q.use_preview = use_preview
      q.preview_key = @preview_key
      q
    end

    def item(code_name, query_parameters = [])
      q = DeliveryQuery.new project_id: @project_id,
                            code_name: code_name,
                            qp: query_parameters,
                            content_link_url_resolver: @content_link_url_resolver
      q.use_preview = use_preview
      q.preview_key = @preview_key
      q
    end
  end
end
