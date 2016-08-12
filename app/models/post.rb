class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :title, type: String

  field :source, type: String

  field :height, type: Integer
  field :width, type: Integer

  has_mongoid_attached_file :post_image, styles: { thumb: "200x200>" }
  validates_attachment_content_type :post_image, content_type: /\Aimage\/.*\Z/

  field :overdose, type: Integer, default: 0
  field :moe_shortage, type: Integer, default: 0

  belongs_to :user, class_name: "User", inverse_of: :posts

  belongs_to :author, class_name: "Author", inverse_of: :posts

  has_many :comments, class_name: "Comment", inverse_of: :post

  has_and_belongs_to_many :tags, class_name: "Tag", inverse_of: :posts

  field :report, type: Boolean, default: false
  alias_method :report?, :report
  has_one :report_user, class_name: "User"
  field :report_reason, type: String

end
