class Post < ApplicationRecord

    # File
    has_one_attached :post_image

    validates :post_image, presence: true,
        image: true,
        image_size: { range: 0..50.megabytes }

    validates :md5, uniqueness: { message: ": The file already exists (MD5 already exists in our base)" }, presence: true

    validate :image_dimensions, :on => :create

    belongs_to :report_user, class_name: "User", inverse_of: nil, optional: true
    belongs_to :user, class_name: "User", inverse_of: :posts, touch: true
    belongs_to :author, class_name: "Author", inverse_of: :posts, optional: true

    has_many :comments, class_name: "Comment", inverse_of: :post

    has_and_belongs_to_many :tags, class_name: "Tag", inverse_of: :posts

    private
    def image_dimensions
        required_min_width = ConfigHelper.min_img_width
        required_min_height = ConfigHelper.min_img_height
        required_max_width = ConfigHelper.max_img_width
        required_max_height = ConfigHelper.max_img_height

        errors.add(:image, "Width must be larger than #{required_min_width}px") unless width >= required_min_width
        errors.add(:image, "Height must be higher than #{required_min_height}px") unless height >= required_min_height
        errors.add(:image, "Width must be smaller than #{required_max_dimensions}px") unless width <= required_max_width
        errors.add(:image, "Height must be smaller than #{required_max_dimensions}px") unless height <= required_max_height
    end
end
