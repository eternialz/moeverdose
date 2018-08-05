class Level < ApplicationRecord
  has_many :user, class_name: "User", inverse_of: :levels

  # Identification
  field :name, type: String
  field :rank, type: Integer, default: 0
  validates :rank, uniqueness: true

  # Data
  field :final, type: Boolean, default: false
  validates :final, uniqueness: true, if: :final?
  field :max_exp, type: Integer
  field :color, type: String, default: "#1AB"

  def final?
    final == true
  end

end
