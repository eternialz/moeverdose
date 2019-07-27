class Tag < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # type: String => Tag's type (see Tag::Type)
    # posts_count: Integer => Number of posts with this tag
    #
    # timestamps => yes
    #
    # aliases: Array<Alias> => All tags aliases
    # main_alias: Alias => Tag's displayed name. Useful for eager loading
    # author: Author => If tag is of type 'author', linked to author
    # posts: Array<Post> => All posts contening this tag
    ####################################################################
    
    # Disable STI
    self.inheritance_column = :_type_disabled

    has_many :aliases
    has_one :main_alias, -> { where(main: true) }, class_name: "Alias"

    has_and_belongs_to_many :posts, class_name: "Post", inverse_of: :tags

    has_one :author, class_name: "Author", inverse_of: :tag

    scope :popular, -> {
        order('posts_count DESC')
    }

    module Type
        def self.all
            ['content', 'character', 'author', 'copyright']
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
        self.main_alias.name
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
