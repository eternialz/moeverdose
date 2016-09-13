class Level
  include Mongoid::Document

  has_many :user, class_name: "User", inverse_of: :levels

  # Identification
  field :name, type: String
  field :rank, type: Integer, default: 0
  validates :rank, uniqueness: true

  # Data
  field :last, type: Boolean, default: false
  validates :last, uniqueness: true, if: :last_is_true?
  field :max_exp, type: Integer
  field :color, type: String, default: "#1AB"

  def last_is_true?
    last == true
  end

end
