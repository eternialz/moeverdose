class New < ApplicationRecord

  field :title, type: String
  validates :title, presence: true
  field :text, type: String
  validates :text, presence: true

end
