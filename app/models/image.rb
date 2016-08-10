class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :path, type: String

  field :height, type: Integer
  field :width, type: Integer
end
