require 'delegate'

class TagLogic < SimpleDelegator
    def self.find_or_create(name, type, post)

        type = type.to_sym

        tag = Tag.where(name: name, type: type)
        if tag.empty?
            tag = Tag.create(name: name, type: type)

        post.tags << tag
        post.save
    end

    def self.find_or_create_author(name, post)
        name = name.downcase.tr(" ", "_")
        tag = Tag.where(name: name, type: :author)
        if tag.empty?
            tag = Tag.create(name: name, type: :author)
            author = Author.create(name: name)
        else
            author = Author.find_by({name: name})
        end
        author.posts << post

        post.tags << tag
        author.save
        post.author = author
        post.save
    end
end
