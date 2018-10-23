class Level < ApplicationRecord
  has_many :user, inverse_of: :levels

  # Identification
  validates :rank, uniqueness: true

  # Data
  validates :final, uniqueness: true, if: :final?
  alias_attribute :final?, :final
end
