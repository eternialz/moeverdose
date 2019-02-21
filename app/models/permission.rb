class Permission < ApplicationRecord
    belongs_to :user
    belongs_to :permissions_type
end
