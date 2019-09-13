class PostService
    def self.assign_id(new_post)
        last_post = Post.last
        new_post.number = if !last_post.nil?
                              last_post.number + 1
                          else
                              1
                          end
    end

    def self.search_posts(query, blacklist)
        posts = if query.blank?
                    if blacklist.blank?
                        PostService.all_posts
                    else
                        PostService.all_posts_with_blacklist(blacklist)
                    end
                elsif blacklist.blank?
                    PostService.query(query)
                else
                    PostService.query_with_blacklist(query, blacklist)
                end

        posts
    end

    def self.query(query)
        posts_tags_ids = posts_tags(query)

        posts = Post.select(:tags_list)
                    .joins("LEFT OUTER JOIN(#{RawSqlService.tags_array}) as \"array_tags\" ON \"array_tags\".\"id\" = \"posts\".\"id\"")
                    .where('array_tags.tags_list @> cast(array[?] as bigint[])', posts_tags_ids)
                    .eager_load(tags: [:aliases, :main_alias], reports: [:user])
                    .with_attached_post_image
        safe_posts posts
    end

    def self.query_with_blacklist(query, blacklist)
        posts_tags_ids = posts_tags(query)
        blacklisted_posts_tags_ids = blacklist.map(&:id)

        posts = Post.select(:tags_list)
                    .joins("LEFT OUTER JOIN(#{RawSqlService.tags_array}) as \"array_tags\" ON \"array_tags\".\"id\" = \"posts\".\"id\"")
                    .where('array_tags.tags_list @> cast(array[?] as bigint[])', posts_tags_ids)
                    .where.not('array_tags.tags_list && cast(array[?] as bigint[])', blacklisted_posts_tags_ids)
                    .eager_load(tags: [:aliases, :main_alias], reports: [:user])
                    .with_attached_post_image
        safe_posts posts
    end

    def self.all_posts
        posts = Post
                .eager_load(tags: [:aliases, :main_alias], reports: [:user])
                .with_attached_post_image
        safe_posts posts
    end

    def self.all_posts_with_blacklist(blacklist)
        blacklisted_posts_tags_ids = blacklist.map(&:id)

        posts = Post.select(:tags_list)
                    .joins("LEFT OUTER JOIN(#{RawSqlService.tags_array}) as \"array_tags\" ON \"array_tags\".\"id\" = \"posts\".\"id\"")
                    .where.not('array_tags.tags_list && cast(array[?] as bigint[])', blacklisted_posts_tags_ids)
                    .eager_load(tags: [:aliases, :main_alias], reports: [:user])
                    .with_attached_post_image
        safe_posts posts
    end

    def self.posts_tags(query)
        query = query.downcase.split.uniq
        tags = Tag.includes(:aliases).where(aliases: { name: query }).map(&:id)
        tags
    end

    def self.set_post_tags(params, post)
        params[:tags].split(' ').each do |tag|
            TagService.find_or_create(tag, :content, post)
        end

        params[:characters].split(' ') do |character|
            TagService.find_or_create(character, :character, post)
        end
    end

    def self.set_post_user(post, user)
        post.user = user
        UserService.update_level(user)
    end

    def self.safe_posts(posts)
        posts.where(Post.joins(:reports)
                        .group('posts.id')
                        .having('count(reports) > ?', ConfigHelper.report_limit))
    end
end
