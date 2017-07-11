require 'delegate'

class PostLogic < SimpleDelegator
    def get_different_tags
        character = []
        author = []
        tag = []
        self.__getobj__.tags.each do |t|
            if t.content?
                tag << t.names[0]
            elsif t.character?
                character << t.names[0]
            elsif t.author?
                author << t.names[0]
            end
        end
        return {tags: tag, characters: character, authors: author}
    end

    def self.set_id(new_post)
        last_post = Post.last
        if !last_post.nil?
            new_post.number = last_post.number + 1
        else
            return 1
        end
    end

    def self.query(query, page, posts_per_page)
        posts_tags_ids, ignored = posts_tags(query)

        return [Kaminari.paginate_array(Post.where(
            report: :false,
            :tag_ids.all => posts_tags_ids,
        ).order('created_at DESC')).page(page).per(posts_per_page),
        ignored]
    end

    def self.query_with_blacklist(query, blacklist, page, posts_per_page)
        posts_tags_ids, ignored = posts_tags(query)
        blacklisted_posts_tags_ids = posts_tags(blacklist)[0]

        return [Kaminari.paginate_array(Post.where(
            report: :false,
            :tag_ids.all => posts_tags_ids,
            :tag_ids.nin => blacklisted_posts_tags_ids
        ).order('created_at DESC')).page(page).per(posts_per_page),
        ignored]
    end

    def self.all_posts(page, posts_per_page)
        return Kaminari.paginate_array(Post.where(
            report: :false
        ).order('created_at DESC')).page(page).per(posts_per_page)
    end

    def self.all_posts_with_blacklist(blacklist, page, posts_per_page)
        blacklisted_posts_tags_ids = posts_tags(blacklist)

        return Kaminari.paginate_array(Post.where(
            report: :false,
            :tag_ids.nin => blacklisted_posts_tags_ids
        ).order('created_at DESC')).page(page).per(posts_per_page)
    end

    private
    def self.posts_tags(query)
        query = query.split().uniq() # Change query into an array and remove duplicates
        tags = Tag.where(:names.in => query).map do |t| t.id end
        return [tags, query.length() != tags.length()]
        # [0] = all found tags, [1] if one or more nonexisting tags were ignored
    end
end
