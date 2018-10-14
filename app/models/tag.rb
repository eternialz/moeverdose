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

    def name
        Alias.where(tag_id: self.id, main: true).first&.name
    end

    def names
        self.aliases.map do |a|
          a.name
        end
    end

    def opt_names
      # Optionnal names (alias.main = false)
      self.aliases.where(main: false).map do |a|
          a.name
        end
    end
end
