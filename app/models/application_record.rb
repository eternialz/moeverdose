class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    include ActiveModel::Serializers::JSON
end
