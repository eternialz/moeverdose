class Level
  include Mongoid::Document

  has_many :user, class_name: "User", inverse_of: :levels

  # Identification
  field :name, type: String
  field :rank, type: Integer, default: 0
  validates :rank, uniqueness: true

  # Data
  field :last, type: Boolean, default: false
  field :max_exp, type: Integer
  field :color, type: String, default: "#1AB"

end
