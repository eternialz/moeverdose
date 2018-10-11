class Author < ApplicationRecord

    belongs_to :tag, class_name: "Tag", inverse_of: :author
    has_many :posts, class_name: "Post", inverse_of: :author

    validates :tag, presence: true
    validates :name, presence: true

end
