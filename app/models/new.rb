class New
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :text, type: String

end
