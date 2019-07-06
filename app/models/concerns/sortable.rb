module Sortable
    extend ActiveSupport::Concern

    module ClassMethods
        def sort_by(sorting_params)
            results = self.where(nil)

            # Apply sorting
            sorting_params.each do |key, value|
                results = results.public_send(key, value) if value.present? && ["asc", "desc"].include?(value) 
            end

            results
        end

        def self.sort_options
            [:created_at]
        end
    end

    included do
        scope :created_at, -> (direction) { order("created_at #{direction}") }
    end
end
