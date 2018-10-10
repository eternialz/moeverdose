class Alias < ApplicationRecord
    validates :name, uniqueness: {scope: :tag_id}
    validates :name, presence: true
    validates :main, uniqueness: {scope: :tag_id}

    belongs_to :tag
end
