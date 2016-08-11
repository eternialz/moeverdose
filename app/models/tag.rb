class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  field :posts_count, type: Integer, default: 0
  has_and_belongs_to_many :posts, class_name: "Post", inverse_of: :tags

  #Type of post we exclude possibility to have multiple type
  has_one :author, class_name: "Author"
  validates :author, presence: true, uniqueness: true, if: ["character.nil?", " content.nil?"]
  validates :author, absence: true, if: "!character.nil?"
  validates :author, absence: true, if: "!content.nil?"

  field :character, type: String
  validates :character, presence: true, uniqueness: true, if: ["author.nil?", " content.nil?"]
  validates :character, absence: true, if: "!author.nil?"
  validates :character, absence: true, if: "!content.nil?"

  field :content, type: String
  validates :content, presence: true, uniqueness: true, if: ["character.nil?", " author.nil?"]
  validates :content, absence: true, if: "!author.nil?"
  validates :content, absence: true, if: "!character.nil?"
end
