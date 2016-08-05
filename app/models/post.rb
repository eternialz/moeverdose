class Post
  field :title, type: String

  field :image, type: String

  field :score, type: Integer, default: 0

  belongs_to :user, class_name: "User", inverse_of: :posts
end
