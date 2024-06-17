# frozen_string_literal: true

require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      class CollectionAssociation < Association
        # orderable associated objects
        register_instance_option :orderable do
          false
        end

        register_instance_option :partial do
          nested_form ? :form_nested_many : :form_filtering_multiselect
        end

        def collection(scope = nil)
          if scope
            super
          elsif associated_collection_cache_all
            selected = selected_ids
            i = 0
            super.sort_by { |a| [selected.index(a[1]) || selected.size, i += 1] }
          else
            value.map { |o| [o.send(associated_object_label_method), o.send(associated_primary_key)] }
          end
        end

        def associated_prepopulate_params
          {associated_model_config.abstract_model.param_key => {association.foreign_key => bindings[:object].try(:id)}}
        end

        def multiple?
          true
        end

        def selected_ids
          value.map { |s| s.send(associated_primary_key).to_s }
        end
      end
    end
  end
end
