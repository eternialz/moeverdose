class Author < ApplicationRecord

    belongs_to :tag, class_name: "Tag", inverse_of: :author
    has_and_belongs_to_many :posts, class_name: "Post", inverse_of: :author

    validates :tag, presence: true
    validates :name, presence: true

end
