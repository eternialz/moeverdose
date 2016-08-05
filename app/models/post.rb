class Post
  field :title, type: String

  field :image, type: String

  field :score, type: Integer, default: 0

  belongs_to :user, class_name: "User", inverse_of: :posts

  has_many :comments, class_name: "Comment", inverse_of: :post

  field :report, type: Boolean, default: false
  alias_method :report?, :report
end
