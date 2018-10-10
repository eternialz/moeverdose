class Post < ApplicationRecord

    # Identification
    field :number, type: Integer, default: 1
    alias_method :number, :id #Temporary fix

    # File
    has_mongoid_attached_file :post_image,
                              styles: {
                                    thumb: {
                                        :geometry => ConfigHelper.thumb_size + "#",
                                        :animated => false
                                    }
                              },
                              :path => ":rails_root/public/system/:attachment/:id/:style/:file_name-:style.:extension",
                              :url => "/system/:attachment/:id/:style/:file_name-:style.:extension"

    Paperclip.interpolates :file_name do |attachment, style|
        attachment.instance.file_name
    end

    def file_name
        "post-#{self.number}"
    end

    validates_attachment :post_image, presence: true,
        content_type: { content_type: /\Aimage\/.*\Z/ },
        size: { in: 0..50.megabytes }

    field :md5, type: String
    validates :md5, uniqueness: { message: ": The file already exists (MD5 already exists in our base)" }, presence: true

    field :height, type: Integer
    field :width, type: Integer

    validate :image_dimensions, :on => :create

    # Stats
    field :overdose, type: Integer, default: 0
    field :moe_shortage, type: Integer, default: 0

    # Infos
    field :title, type: String
    field :source, type: String, default: ""
    field :description, type: String, default: ""

    # Report
    field :report, type: Boolean, default: false
    alias_method :report?, :report
    belongs_to :report_user, class_name: "User", inverse_of: nil, optional: true
    field :report_reason, type: String


    belongs_to :user, class_name: "User", inverse_of: :posts, touch: true

    belongs_to :author, class_name: "Author", inverse_of: :posts, optional: true

    has_and_belongs_to_many :comments, class_name: "Comment", inverse_of: :post

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
