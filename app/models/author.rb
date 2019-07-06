class Author < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # name: String => Self exp
    # biography: String => Author's biography
    # website: String => Link to the author's website / DA page, etc...
    #
    # timestamps => yes
    #
    # tag: Tag => Tag linked to the author
    ####################################################################

    # Relations
    belongs_to :tag, class_name: "Tag", inverse_of: :author
    has_many :posts, class_name: "Post", inverse_of: :author

    validates :tag, presence: true
    validates :name, presence: true

    # Sorting
    include Sortable

    scope :alphabetical, -> (direction = "desc") { order("name #{direction}") }
    scope :posts, -> (direction = "desc") { includes(:tag).order("tags.posts_count #{direction}") }

    def self.sort_scopes
        [:alphabetical, :posts]
    end

    def self.sort_options
        [
            {alphabetical: {desc: "Alpabetical order"}},
            {alphabetical: {asc: "Reverse alphabetical order"}},
            {posts: {desc: "Most posts first"}},
            {posts: {asc: "Least posts first"}},
        ]
    end
end
