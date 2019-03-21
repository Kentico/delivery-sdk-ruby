require 'nokogiri'

module KenticoCloud
  module Delivery
    module Resolvers
      # Locates <object data-type="item"> tags in content and calls a user-defined
      # method to supply the output for the content item.
      # See https://github.com/Kentico/delivery-sdk-ruby#resolving-inline-content
      class InlineContentItemResolver
        def initialize(callback = nil)
          @callback = callback
        end

        # Resolves all inline content items in the content.
        #
        # * *Args*:
        #   - *content* (+string+) The string value stored in the element
        #   - *inline_items* (+Array+) ContentItems referenced by the content from the 'modular_content' JSON node
        #
        # * *Returns*:
        #   - +string+ The original content passed, with all <object data-type="item"> replaced with custom output
        def resolve(content, inline_items)
          doc = Nokogiri::HTML.parse(content).xpath('//body')
          tags = doc.xpath('//object[@type="application/kenticocloud"][@data-type="item"]')
          tags.each do |tag|
            output = resolve_tag tag, inline_items
            el = doc.at_xpath(
              '//object[@type="application/kenticocloud"][@data-type="item"][@data-codename=$value]',
              nil,
              value: tag['data-codename']
            )
            el.swap(output) unless output.nil?
          end
          doc.inner_html
        end

        private

        # Accepts a tag found in the content and tries to locate matching
        # ContentItem from JSON response.
        #
        # * *Args*:
        #   - *tag* (+string+) A <object data-type="item"> tag found in the content
        #   - *inline_items* (+Array+) ContentItems referenced by the content from the 'modular_content' JSON node
        #
        # * *Returns*:
        #   - +string+ The custom output generated by the +provide_output+ method
        def resolve_tag(tag, inline_items)
          matches = inline_items.select { |item| item.system.codename == tag['data-codename'].to_s }
          provide_output matches
        end

        # Generates custom output for a content item using the +resolve_item+
        # method.
        #
        # * *Args*:
        #   - *matches* (+Array+) The ContentItems from the 'modular_content' JSON node which match the code name of a particular <object data-type="item"> tag
        #
        # * *Returns*:
        #   - +string+ The custom output generated by the +resolve_item+ method
        def provide_output(matches)
          if !matches.empty?
            if @callback.nil?
              resolve_item matches[0]
            else
              @callback.call matches[0]
            end
          end
        end
      end
    end
  end
end
