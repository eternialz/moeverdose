class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :user, class_name: "User", inverse_of: :comments

  belongs_to :post, class_name: "Post", inverse_of: :comments
  field :text, type: String
  
  field :score, type: Integer, default: 0

  field :report, type: Boolean, default: false
  alias_method :report?, :report
  has_one :report_user, class_name: "User"
  field :report_reason, type: String
end
