class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  field :posts_count, type: Integer, default: 0
  has_and_belongs_to_many :posts, class_name: "Post", inverse_of: :tags

  field :type, type: String
  validates :character, presence: true
end
