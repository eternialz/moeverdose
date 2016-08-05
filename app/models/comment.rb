class Comment
  
  belongs_to :user, class_name: "User", inverse_of: :comments

  belongs_to :post, class_name: "Post", inverse_of: :comments
  field :text, type: String
  
  field :score, type: Integer

  field :report, type: Boolean, default: false
  alias_method :report?, :report
end
