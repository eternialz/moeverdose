class User < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # email: String => Self exp, used by Devise
    # encrypted_password: String => Self exp (see Devise doc)
    # reset_password_token: String => Self exp (see Devise doc)
    # reset_password_sent_at: Date => Self exp (see Devise doc)
    # remember_created_at: Date => Self exp (see Devise doc)
    # sign_in_count: Integer => Self exp (see Devise doc)
    # current_sign_in_at: Date => Self exp (see Devise doc)
    # last_sign_in_at: Date => Self exp (see Devise doc)
    # current_sign_in_ip: inet => Self exp (see Devise doc)
    # last_sign_in_ip: inet => Self exp (see Devise doc)
    # confirmation_token: String => Self exp (see Devise doc)
    # confirmation_at: Date => Self exp (see Devise doc)
    # confirmation_sent_at: Date => Self exp (see Devise doc)
    # unconfirmation_email: String => Self exp (see Devise doc)
    # 
    # name: String => Username
    # biography: String => Self exp
    # website: String => User's website / blog
    # twitter: String => Link to Twitter account
    # facebook: String => Link to Facebook account
    # upload_count: Integer => Number of posts uploaded by the user
    # exp: Integer => User's experience, used for levels
    # report: Boolean => Is the user reported
    # banned: Boolean => Is the user reported
    # role: String => User's role. See User::Role. Default 'user'
    # favorites_tags: String => User's favorite tags separated with a space
    # blacklisted_tags: String => User's blacklisted tags separated with a space
    # avatar: ActiveStorage::Attachment => Self exp
    # 
    # timestamps => yes
    #
    # posts: Array<Post> => Posts uploaded by user
    # level: Level => Self exp
    # favorites: Array<Post> => Self exp
    # liked_posts: Array<Post> => User's overdose
    # disliked_posts: Array<Post> => User's shortage
    # favorites_tags: Array<Tag> => User's favorite tags
    # blacklisted_tags: Array<Tag> => User's blacklisted tags
    # comments: Array<Comment> => Self exp
    # permissions: Array<Permission> => User's authorization for personnal data processing
    # reported_posts: Array<Post> => All posts reported by the user
    #
    ####################################################################
    
    devise :database_authenticatable, :registerable, :confirmable,
        :recoverable, :rememberable, :trackable, :validatable
    after_initialize :set_default_role, if: :new_record?

    # Base properties
    validates :name,  uniqueness: true, presence: true
    validates :email, presence: true

    # Avatar
    has_one_attached :avatar
    validates :avatar, content_type: ["image/png", "image/jpeg"],
        size: { less_than: 500.kilobytes }

    # Posts
    has_many :posts, class_name: "Post", inverse_of: :user

    # Stats
    belongs_to :level, class_name: "Level", inverse_of: :users, default: -> {
        Level.all.order("rank ASC").first
    }

    # Posts marked the user
    has_and_belongs_to_many :favorites, class_name: "Post", inverse_of: nil, join_table: :favorites_posts_users
    has_and_belongs_to_many :liked_posts, class_name: "Post", inverse_of: nil, join_table: :liked_posts_users
    has_and_belongs_to_many :disliked_posts, class_name: "Post", inverse_of: nil, join_table: :disliked_posts_users

    # Tags marked by the user
    has_and_belongs_to_many :favorites_tags, class_name: "Tag", inverse_of: nil, join_table: :favorites_tags_users
    has_and_belongs_to_many :blacklisted_tags, class_name: "Tag", inverse_of: nil, join_table: :blacklisted_tags_users

    # Comments
    has_many :comments, class_name: "Comment", inverse_of: :user

    # User security
    alias_attribute :report?, :report
    alias_attribute :banned?, :banned

    # GDPR
    has_many :permissions
    accepts_nested_attributes_for :permissions

    # Prevent banned user authentications
    def active_for_authentication?
        super && !self.banned?
    end

    def inactive_message # Custom error message for banned user
        !self.banned? ? super : :banned
    end

    def team?
        ['administrator', 'moderator'].include? self.role
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

    private
    def set_default_role
        self.role ||= 'user'
    end
end
