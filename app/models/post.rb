class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :title, type: String

  field :source, type: String, default: ""

  field :height, type: Integer
  field :width, type: Integer

  has_mongoid_attached_file :post_image, styles: { thumb: "200x200#" }
  validates_attachment_content_type :post_image, content_type: /\Aimage\/.*\Z/

  field :overdose, type: Integer, default: 0
  field :moe_shortage, type: Integer, default: 0

  field :report, type: Boolean, default: false
  alias_method :report?, :report
  has_one :report_user, class_name: "User"
  field :report_reason, type: String

end
