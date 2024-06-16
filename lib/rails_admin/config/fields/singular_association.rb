# frozen_string_literal: true

require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      class SingularAssociation < Association
        register_instance_option :filter_operators do
          %w[_discard like not_like is starts_with ends_with] + (required? ? [] : %w[_separator _present _blank])
        end

        register_instance_option :formatted_value do
          (o = value) && o.send(associated_model_config.object_label_method)
        end

        register_instance_option :partial do
          nested_form ? :form_nested_one : :form_filtering_select
        end

        def collection(scope = nil)
          if associated_collection_cache_all || scope
            super
          else
            [[formatted_value, selected_id]]
          end
        end

        def multiple?
          false
        end

        def selected_id
          raise NoMethodError # abstract
        end

        def parse_input(params)
          return unless nested_form && params[method_name].try(:[], :id).present?

          ids = associated_model_config.abstract_model.parse_id(params[method_name][:id])
          ids = ids.to_composite_keys.to_s if ids.respond_to?(:to_composite_keys)
          params[method_name][:id] = ids
        end
      end
    end
  end
end
