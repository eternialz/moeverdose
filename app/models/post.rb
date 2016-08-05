class Post
  field :title, type: String

  field :image, type: String

  field :score, type: Integer, default: 0

  belongs_to :user, class_name: "User", inverse_of: :posts

  has_many :comments, class_name: "Comment", inverse_of: :post

  has_and_belongs_to_many :tags, class_name: "Tag", inverse_of: :posts

  field :report, type: Boolean, default: false
  alias_method :report?, :report
end
