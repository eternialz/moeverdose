class Alias < ApplicationRecord
    validates :name, uniqueness: {scope: :tag_id}
    validates :name, presence: true
    validates :main, uniqueness: {scope: :tag_id}, if: :main

    belongs_to :tag, optional: true
end
