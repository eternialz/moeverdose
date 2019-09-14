class Post < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # md5: String => MD5 hash of the image
    # height: Integer => Image height
    # width: Integer => Image width
    # overdose: Integer => Number of overdose (like) for the post
    # moe_shortage: Integer => Number of shortage (dislike) for the post
    # title: String => Self exp
    # source: String => Image origin (can be URL)
    # description: String => Description for the posts
    # post_image: ActiveStorage::Attachment => Image attached to the post
    #
    # timestamps => yes
    #
    # author: Author : Post's image's author
    # comments: Array<Comment> => All posts comments
    # reports: Array<Report> => Reports on the posts
    # tags: Array<Tag> => Tags linked to posts
    # user: User => User who posted the image
    #
    ####################################################################

    def self.image_types
        MIME::Types.select do |t|
            t.media_type == 'image'
        end.map(&:content_type)
    end

    alias_attribute :number, :id

    # File
    has_one_attached :post_image

    validates :post_image, attached: true,
                           content_type: { in: Post.image_types },
                           size: { less_than_or_equal_to: 50.megabytes },
                           dimension: {
                               min: ConfigHelper.min_img_width..ConfigHelper.min_img_height,
                               max: ConfigHelper.max_img_width..ConfigHelper.max_img_height
                           }

    validates :md5, uniqueness: { message: 'The file already exists (MD5 already exists in our base)' }, presence: true

    has_many :reports, as: :reportable
    belongs_to :user, class_name: 'User', inverse_of: :posts, touch: true
    belongs_to :author, class_name: 'Author', inverse_of: :posts, optional: true

    has_many :comments, class_name: 'Comment', inverse_of: :post
    has_many :claims, class_name: 'Claim', inverse_of: :post

    has_and_belongs_to_many :tags, class_name: 'Tag', inverse_of: :posts

    # Sorting
    include Sortable

    # scope :comments, -> (direction = "desc") { order("comment_count #{direction}") }

    scope :created_at, ->(direction) { order("posts.created_at #{direction}") }
    scope :overdose, ->(direction = 'desc') { order("posts.overdose #{direction}") }
    scope :shortage, ->(direction = 'desc') { order("posts.moe_shortage #{direction}") }

    def report
        reports.size >= ConfigHelper.report_limit
    end
    alias report? report

    def self.sort_scopes
        [:created_at, :overdose, :shortage]
    end

    def self.sort_options
        [
            { created_at: { desc: 'Uploaded last' } },
            { created_at: { asc: 'Uploaded first' } },
            { overdose: { desc: 'Most overdose first' } },
            { shortage: { desc: 'Most shortage first' } }
        ]
    end

    def self.sizes
        {
            thumbnail: '200x200'
        }
    end

    def post_image_thumbnail
        post_image.variant(
            combine_options: {
                resize: "#{Post.sizes[:thumbnail]}^",
                extent: Post.sizes[:thumbnail],
                gravity: 'center'
            }
        ).processed
    end

    def post_image_path
        ActiveStorage::Blob.service.send(:path_for, post_image.key)
    end
end
