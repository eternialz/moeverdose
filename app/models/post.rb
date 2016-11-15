class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  # Identification
  field :title, type: String
  field :source, type: String, default: ""

  # File
  has_mongoid_attached_file :post_image, styles: { thumb: "200x200#" }
  validates_attachment :post_image, presence: true,
    content_type: { content_type: /\Aimage\/.*\Z/ },
    size: { in: 0..10.megabytes }

  field :height, type: Integer
  field :width, type: Integer

  validate :image_dimensions, :on => :create

  # Stats
  field :overdose, type: Integer, default: 0
  field :moe_shortage, type: Integer, default: 0

  # Report
  field :report, type: Boolean, default: false
  alias_method :report?, :report
  belongs_to :report_user, class_name: "User", inverse_of: nil, optional: true
  field :report_reason, type: String


  belongs_to :user, class_name: "User", inverse_of: :posts

  belongs_to :author, class_name: "Author", inverse_of: :posts

  has_and_belongs_to_many :comments, class_name: "Comment", inverse_of: :post

  has_and_belongs_to_many :tags, class_name: "Tag", inverse_of: :posts

  private
  def image_dimensions
    required_min_width = 200
    required_min_height = 200
    required_max_dimensions = 10000

    errors.add(:image, "Width must be higher than #{required_min_width}px") unless width >= required_min_width
    errors.add(:image, "Height must be higher than #{required_min_height}px") unless height >= required_min_height
    errors.add(:image, "Width must be lower than #{required_max_dimensions}px") unless width <= required_max_dimensions
    errors.add(:image, "Height must be lower than #{required_max_dimensions}px") unless height <= required_max_dimensions
  end
end
