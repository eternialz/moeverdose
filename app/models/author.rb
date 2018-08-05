class Author < ApplicationRecord

    field :name, type: String
    validates :name, presence: true

    field :biography, type: String, default: ""

    has_and_belongs_to_many :posts, class_name: "Post", inverse_of: :author

    belongs_to :tag, class_name: "Tag", inverse_of: :author
    validates :tag, presence: true

    field :websites, type: Array, default: []
end
