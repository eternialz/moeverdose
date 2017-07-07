class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :names, type: Array, default: []
  validates :names, presence: true

  field :posts_count, type: Integer, default: 0
  has_and_belongs_to_many :posts, class_name: "Post", inverse_of: :tags

  field :type, type: Symbol

  module Type
    def self.all
      [:content, :character, :author]
    end

    self.all.each do |type|
      define_method("#{type}?") do
        self.type == type
      end
    end
  end
  include Tag::Type
  validates :type, inclusion: {in: Tag::Type.all}

end
