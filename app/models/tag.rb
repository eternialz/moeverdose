class Tag < ApplicationRecord

    has_many :aliases

    has_and_belongs_to_many :posts, class_name: "Post", inverse_of: :tags

    has_one :author, class_name: "Author", inverse_of: :tag

    module Type
        def self.all
            ['content', 'character', 'author']
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
