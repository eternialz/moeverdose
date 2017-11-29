class New
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  validates :title, presence: true
  field :text, type: String
  validates :text, presence: true

end
