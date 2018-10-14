require 'delegate'

class TagLogic < SimpleDelegator
    def self.find_or_create(name, type, post)

        type = type.to_sym

        tag = Tag.includes(:aliases).where(aliases: {name: name}, type: type)
        if tag.empty?
            tag = Tag.create(type: type)
            a = Alias.create(tag_id: tag.id, name: name, main: true)
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
        tag = Tag.includes(:aliases).where(aliases: {name: name}, type: :author)
        if tag.empty?
            tag = Tag.create(type: :author)
            a = Alias.create(tag_id: tag.id, name: name, main: true)
            author = Author.new(name: name, tag: tag)
        else
            begin
                author = Author.find_by({name: name})
            rescue
                author = Author.new(name: name, tag: tag)
            end
        end

        post.tags << tag
        post.author = author
        return author
    end
end
