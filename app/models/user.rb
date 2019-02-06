class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :confirmable,
        :recoverable, :rememberable, :trackable, :validatable
    validates :name,  uniqueness: true, presence: true

    validates :email, presence: true

    # Avatar
    has_one_attached :avatar

    validates :avatar, content_type: ["image/png", "image/jpeg"],
        size: { less_than: 500.kilobytes }

    # Posts
    has_many :posts, class_name: "Post", inverse_of: :user

    # Stats
    belongs_to :level, class_name: "Level", inverse_of: :user

    # Posts marked as favorite of the user
    has_and_belongs_to_many :favorites, class_name: "Post", inverse_of: nil, join_table: :favorites_posts_users
    has_and_belongs_to_many :liked_posts, class_name: "Post", inverse_of: nil, join_table: :liked_posts_users
    has_and_belongs_to_many :disliked_posts, class_name: "Post", inverse_of: nil, join_table: :disliked_posts_users

    has_and_belongs_to_many :favorites_tags, class_name: "Tag", inverse_of: nil, join_table: :favorites_tags_users
    has_and_belongs_to_many :blacklisted_tags, class_name: "Tag", inverse_of: nil, join_table: :blacklisted_tags_users

    # Comments
    has_many :comments, class_name: "Comment", inverse_of: :user

    # User security
    alias_attribute :report?, :report
    alias_attribute :banned?, :banned

    def active_for_authentication? # Prevent banned user authentications
        super && !self.banned?
    end

    def inactive_message # Custom error message for banned user
        !self.banned? ? super : :banned
    end

    # Reported posts
    has_and_belongs_to_many :reported_posts, class_name: "Post", inverse_of: nil, join_table: :reported_posts_users

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
end
