class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  validates :email, presence: true

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :name, type: String
  validates :name,  uniqueness: true
  validates :name,  presence: true

  field :bio, type: String, default: ""

  field :website,   type: String, default: ""

  field :twitter,   type: String, default: ""
  field :facebook,  type: String, default: ""

  validates :email, presence: true

  field :encrypted_password
  validates :encrypted_password, presence: true, confirmation: true

  has_mongoid_attached_file :avatar, styles: { :thumb => {:geometry => "120x120#"}, :tiny => {:geometry => "60x60#"}}, default_url: "/images/default_user.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_mongoid_attached_file :banner, styles: { :normal => {:geometry => "1600x440#"}}, default_url: "/images/default_banner.png"
  validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/

  has_many :posts, class_name: "Post", inverse_of: :user
  #Posts marked as favorite of the user
  has_many :favorites, class_name: "Post", inverse_of: nil
  has_many :liked_posts, class_name: "Post", inverse_of: nil
  has_many :disliked_posts, class_name: "Post", inverse_of: nil

  has_many :comments, class_name: "Comment", inverse_of: :user

  field :favorites_tags, type: String, default: ""
  field :blacklisted_tags, type: String, default: ""

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
