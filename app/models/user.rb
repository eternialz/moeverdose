class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :name, type: String
  validates :name, uniqueness: true
  validates :name, presence: true

  field :email, type: String
  validates :email, presence: true

  field :encrypted_password
  validates :encrypted_password, presence: true, confirmation: true

  has_mongoid_attached_file :avatar, styles: { thumb: "200x200>", tiny: "60x60" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_many :posts, class_name: "Post", inverse_of: :user
  #Posts marked as favorite of the user
  has_many :favorites, class_name: "Post"
  has_many :liked_posts, class_name: "Post"
  has_many :disliked_posts, class_name: "Post"

  has_many :comments, class_name: "Comment", inverse_of: :user

  field :report, type: Boolean, default: false
  alias_method :report?, :report

  field :role, type: Symbol, default: :user

  module Role
    def self.all
      [:user, :administrator, :contributor, :moderator, :developper]
    end

    self.all.each do |role|
      define_method("#{role}?") do
        self.role == role
      end
    end
  end
  validates :role, inclusion: {in: User::Role.all}
end
