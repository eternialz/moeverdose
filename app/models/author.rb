class Author
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    validates :name, presence: true, uniqueness: true, allow_blank: false

    has_and_belongs_to_many :posts, class_name: "Post", inverse_of: :author

    field :website, type: String

    field :overdose, type: Integer, default: 0
    field :moe_shortage, type: Integer, default: 0

end
