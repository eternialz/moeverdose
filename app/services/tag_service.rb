class TagService
    def self.find_or_create(name, type, post)

        name = sanitize(name)
        type = type.to_sym

        tag = Tag.includes(:aliases).where(aliases: {name: name}, type: type)
        if tag.empty?
            tag = Tag.create(type: type)
            Alias.create(tag_id: tag.id, name: name, main: true)
        end

        post.tags << tag
        return tag;
    end

    def self.change_counts(tags, num)
        tags.each do |t|
            t.posts_count += num
            t.save
        end
    end

    def self.sanitize(tagName)
        tagName.downcase.tr('*~', '').squish.sub(/\A_/, '').sub(/_\z/, '').tr(' ', '_')
    end

    def self.differenciate_tags(tags)
        character = []
        author = []
        copyright = []
        tag = []
        tags.each do |t|
            if t.content?
                tag << t.name
            elsif t.character?
                character << t.name
            elsif t.author?
                author << t.name
            elsif t.copyright?
                copyright << t.name
            end
        end

        return {tags: tag, characters: character, authors: author, copyrights: copyright}
    end

    def self.find_or_create_author(name, post)
        name = sanitize(name)
        tag = Tag.includes(:aliases).where(aliases: {name: name}, type: :author)
        if tag.empty?
            tag = Tag.create(type: :author)
            Alias.create(tag_id: tag.id, name: name, main: true)
            author = Author.new(name: name, tag: tag)
        else
            begin
                author = Author.find_by({name: name})
            rescue
                author = Author.new(name: name, tag: tag)
            end
        end

        post.tags << tag
        return author
    end
end
