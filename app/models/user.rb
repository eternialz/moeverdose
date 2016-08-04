class User

  field :name, type: String
  validates :name, uniqueness: true, message: "already taken"
  validates :name, presence: true, message: "can't be blank"

  field :email, type: String
  validates :email, presence: true

  field :encrypted_password
  validates :encrypted_password, presence: true, confirmation: true

end
