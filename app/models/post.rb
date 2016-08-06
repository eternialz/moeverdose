class Post
  field :title, type: String

  field :source, type: String

  hes_one :image, class_name: "Image"

  field :overdose, type: Integer, default: 0
  field :moe_shortage, type: Integer, default: 0
  field :score, type: Integer, default: 0

  belongs_to :user, class_name: "User", inverse_of: :posts

  belongs_to :author, class_name: "Author", inverse_of: :posts

  has_many :comments, class_name: "Comment", inverse_of: :post

  has_and_belongs_to_many :tags, class_name: "Tag", inverse_of: :posts

  field :report, type: Boolean, default: false
  alias_method :report?, :report
  field :report_user, class_name: "User"
  field :report_reason, type: String

  def calculate_score
    self.score = self.overdose - self.moe_shortage
  end
end
