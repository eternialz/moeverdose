require 'delegate'

class PostLogic < SimpleDelegator
    def get_different_tags
        character = []
        author = []
        tag = []
        self.__getobj__.tags.each do |t|
            if t.content?
                tag << t.name
            elsif t.character?
                character << t.name
            elsif t.author?
                author << t.name
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

        return [Kaminari.paginate_array(Post.select(:tags_list)
            .joins("LEFT OUTER JOIN(#{RawSqlLogic.get_tags_array}) as \"array_tags\" ON \"array_tags\".\"id\" = \"posts\".\"id\"")
            .where(report: false)
            .where("array_tags.tags_list @> cast(array[?] as bigint[])", posts_tags_ids)
            .eager_load(tags: [:aliases, :main_alias])
            .with_attached_post_image
            .order(created_at: :desc))
            .page(page).per(posts_per_page),
        ignored]
    end

    def self.query_with_blacklist(query, blacklist, page, posts_per_page)
        posts_tags_ids, ignored = posts_tags(query)
        blacklisted_posts_tags_ids = blacklist.map {|t| t.id}

        return [Kaminari.paginate_array(Post.select(:tags_list)
            .joins("LEFT OUTER JOIN(#{RawSqlLogic.get_tags_array}) as \"array_tags\" ON \"array_tags\".\"id\" = \"posts\".\"id\"")
            .where(report: false)
            .where("array_tags.tags_list @> cast(array[?] as bigint[])", posts_tags_ids)
            .where.not("array_tags.tags_list && cast(array[?] as bigint[])", blacklisted_posts_tags_ids)
            .eager_load(tags: [:aliases, :main_alias])
            .with_attached_post_image
            .order(created_at: :desc))
            .page(page).per(posts_per_page),
        ignored]
    end

    def self.all_posts(page, posts_per_page)
      return Kaminari.paginate_array(Post
            .where(report: false)
            .eager_load(tags: [:aliases, :main_alias])
            .with_attached_post_image
            .order(created_at: :desc))
            .page(page).per(posts_per_page)
    end

    def self.all_posts_with_blacklist(blacklist, page, posts_per_page)
      blacklisted_posts_tags_ids = blacklist.map {|t| t.id}

      return Kaminari.paginate_array(Post.select(:tags_list)
            .joins("LEFT OUTER JOIN(#{RawSqlLogic.get_tags_array}) as \"array_tags\" ON \"array_tags\".\"id\" = \"posts\".\"id\"")
            .where(report: false)
            .where.not("array_tags.tags_list && cast(array[?] as bigint[])", blacklisted_posts_tags_ids)
            .eager_load(tags: [:aliases, :main_alias])
            .with_attached_post_image
            .order(created_at: :desc))
            .page(page).per(posts_per_page)
    end

    def self.posts_tags(query)
        query = query.downcase.split.uniq # Change query into an array and remove duplicates
        tags = Tag.includes(:aliases).where(aliases: {name: query}).map do |t| t.id end
        return [tags, query.length() != tags.length()]
        # [0] = all found tags, [1] true if one or more nonexisting tags were ignored
    end

    def self.set_post_tags(params, post)
        tags = params[:tags].downcase.split(" ")
        tags.each do |tag|
            TagLogic.find_or_create(tag, :content, post)
        end

        characters = params[:characters].downcase.split(" ")
        characters.each do |character|
            TagLogic.find_or_create(character, :character, post)
        end
    end

    def self.set_post_dimensions(post)
        dimensions = Paperclip::Geometry.from_file(post.post_image.queued_for_write[:original].path)
        post.width, post.height = dimensions.width, dimensions.height
    end

    def self.set_post_user(post, user)
        post.user = user
        user_logic = UserLogic.new(user)
        user_logic.update_level
    end
end
