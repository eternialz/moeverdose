class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
=begin

    validates :name,  uniqueness: true, presence: true

    validates :email, presence: true

    # Banner and Avatar
    has_mongoid_attached_file :avatar,
                                styles: {
                                    :original => {:geometry => "120x120#"},
                                    :tiny => {:geometry => "60x60#"}
                                },
                                default_url: "/images/default_user.png",
                                :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_avatar_file_name-:style.:extension",
                                :url => "/system/:attachment/:id/:style/:normalized_avatar_file_name-:style.:extension"

    Paperclip.interpolates :normalized_avatar_file_name do |attachment, style|
        attachment.instance.normalized_avatar_file_name
    end

    def normalized_avatar_file_name
        "avatar-#{self.name}"
    end

    validates_attachment_content_type :avatar,
        content_type: /\Aimage\/.*\Z/,
        size: { in: 0..0.5.megabytes }

    has_mongoid_attached_file :banner,
                                styles: {
                                    :original => {
                                        :geometry => "1600x300#",
                                        :animated => false
                                    }
                                },
                                :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_banner_file_name-:style.:extension",
                                :url => "/system/:attachment/:id/:style/:normalized_banner_file_name-:style.:extension",
                                default_url: "/images/default_banner.png"

    Paperclip.interpolates :normalized_banner_file_name do |attachment, style|
        attachment.instance.normalized_banner_file_name
    end

    def normalized_banner_file_name
        "banner-#{self.id}"
    end

    validates_attachment_content_type :banner,
        content_type: /\Aimage\/.*\Z/,
        size: { in: 0..1.megabytes }

    # Posts
    has_many :posts, class_name: "Post", inverse_of: :user

    # Stats
    belongs_to :level, class_name: "Level", inverse_of: :user

    # Posts marked as favorite of the user
    has_and_belongs_to_many :favorites, class_name: "Post", inverse_of: nil
    has_and_belongs_to_many :liked_posts, class_name: "Post", inverse_of: nil
    has_and_belongs_to_many :disliked_posts, class_name: "Post", inverse_of: nil

    # Comments
    has_many :comments, class_name: "Comment", inverse_of: :user

    # User security
    alias_method :report?, :report

    alias_method :banned?, :banned

    def active_for_authentication? # Prevent banned user authentications
        super && !self.banned?
    end

    def inactive_message # Custom error message for banned user
        !self.banned? ? super : :banned
    end

    # Reported posts
    has_and_belongs_to_many :reported_posts, class_name: "Post", inverse_of: nil

    # Roles

    module Role
        def self.all
            ['user', 'administrator', 'contributor', 'moderator', 'developper']
        end

        self.all.each do |role|
            define_method("#{role}?") do
                self.role == role
            end
        end
    end
    include User::Role
    validates :role, inclusion: {in: User::Role.all}
=end
end
