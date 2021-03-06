class TagService
    def self.find_or_create(name, type, post)
        name = sanitize(name)
        type = type.to_sym

        tag = Tag.includes(:aliases).where(aliases: { name: name }, type: type)
        if tag.empty?
            tag = Tag.create(type: type)
            Alias.create(tag_id: tag.id, name: name, main: true)
        end

        post.tags << tag
        tag
    end

    def self.change_counts(tags, num)
        tags.each do |t|
            t.posts_count += num
            t.save
        end
    end

    def self.sanitize(tag_name)
        tag_name.downcase.tr('*~', '').squish.sub(/\A_/, '').sub(/_\z/, '').tr(' ', '_')
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

        { tags: tag, characters: character, authors: author, copyrights: copyright }
    end

    def self.find_or_create_author(name, post = nil)
        sanitized_name = sanitize(name)
        author = Author.where(name: sanitized_name).first

        if author.blank?
            tag = Tag.create(type: :author)
            Alias.create(tag_id: tag.id, name: sanitized_name, main: true)

            author = Author.new(name: name, tag: tag)
        end

        post.tags << author.tag if post
        author
    end
end
