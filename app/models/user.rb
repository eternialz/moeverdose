class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :confirmable,
        :recoverable, :rememberable, :trackable, :validatable
    validates :name,  uniqueness: true, presence: true

    validates :email, presence: true
    # Banner and Avatar
    has_one_attcahed :avatar

    validates :avatar, image: true,
        image_size: { range: 0..0.5.megabytes }

    has_one_attached :banner,

    validates :banner, image: true,
        image_size: { range: 0..1.megabytes }

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
