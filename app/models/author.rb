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

    belongs_to :tag, class_name: "Tag", inverse_of: :author
    has_many :posts, class_name: "Post", inverse_of: :author

    validates :tag, presence: true
    validates :name, presence: true

    validates :website, allow_blank: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'You provided an invalid website URL.' }

end
