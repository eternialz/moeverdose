class Author
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  validates :name, presence: true, uniqueness: true

  has_many :posts, class_name: "Post", inverse_of: :author

  field :website, type: String

  field :overdose, type: Integer, default: 0
  field :moe_shortage, type: Integer, default: 0

end
