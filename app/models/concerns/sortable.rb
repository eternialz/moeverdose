module Sortable
    extend ActiveSupport::Concern

    module ClassMethods
        def sort_by(sorting_param)
            results = where(nil)

            sort_by_with_set(sorting_param, results)
        end

        def sort_by_with_set(sorting_param, set)
            results = set

            # Apply sorting
            sorting_param.each do |key, value|
                results = results.public_send(key, value) if ['asc', 'desc'].include?(value)
            end

            results
        end

        def self.sort_options
            [:created_at]
        end
    end

    included do
        scope :created_at, ->(direction) { order("created_at #{direction}") }
    end
end
