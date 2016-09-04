class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :title, type: String

  field :source, type: String, default: ""

  has_mongoid_attached_file :post_image, styles: { thumb: "200x200#" }
  validates_attachment_content_type :post_image, content_type: /\Aimage\/.*\Z/

  field :height, type: Integer
  field :width, type: Integer

  validate :image_dimensions, :on => :create

  field :overdose, type: Integer, default: 0
  field :moe_shortage, type: Integer, default: 0

  belongs_to :user, class_name: "User", inverse_of: :posts

  belongs_to :author, class_name: "Author", inverse_of: :posts

  has_many :comments, class_name: "Comment", inverse_of: :post

  has_and_belongs_to_many :tags, class_name: "Tag", inverse_of: :posts

  field :report, type: Boolean, default: false
  alias_method :report?, :report
  has_one :report_user, class_name: "User", inverse_of: :post
  field :report_reason, type: String

  private

  def image_dimensions
    required_min_width = 200
    required_min_height = 200
    required_max_dimensions = 10000

    errors.add(:image, "Width must be higher than #{required_min_width}px") unless width >= required_min_width
    errors.add(:image, "Height must be higher than #{required_min_height}px") unless height >= required_min_height
    errors.add(:image, "Width + Height must be lower than #{required_max_dimensions}px") unless width + height <= required_max_dimensions
  end

end
