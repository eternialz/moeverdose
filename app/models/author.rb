class Author
  
  field :name, type: String
  validates :name, presence: true, uniqueness: true

  has_many :posts, class_name: "Post", inverse_of: :author

  field :website, type: String

  field :overdose, type: Integer, default: 0
  field :moe_shortage, type: Integer, default: 0
  field :score, type: Integer, default: 0

  def calculate_score
    self.score = self.overdose - self.moe_shortage
  end
end
