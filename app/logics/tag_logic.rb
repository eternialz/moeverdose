require 'delegate'

class TagLogic < SimpleDelegator
    def self.find_or_create(name, type, post)

        type = type.to_sym

        tag = Tag.where(names: name, type: type)
        if tag.empty?
            tag = Tag.create(names: [name], type: type)
        end

        post.tags << tag
    end

    def self.change_counts(tags, num)
        tags.each do |t|
            t.posts_count += num
            t.save
        end
    end

    def self.find_or_create_author(name, post)
        name = name.downcase.tr(" ", "_")
        tag = Tag.where(names: name, type: :author)
        if tag.empty?
            tag = Tag.create(names: [name], type: :author)
            author = Author.new(name: name)
        else
            begin
                author = Author.find_by({name: name})
            rescue
                author = Author.new(name: name)
            end
        end

        post.tags << tag
        post.author = author
        return author
    end
end