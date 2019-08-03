module ConfigHelper
    # GENERAL
    def site_name
        'Moeverdose'
    end

    def chat_url
        'https://discordapp.com/invite/xfCpyJY'
    end

    def source_url
        'https://github.com/eternialz/moeverdose'
    end

    def twitter_url
        'https://twitter.com/moeverdose'
    end

    def items_per_page_list
        [8, 16, 24, 32]
    end

    def default_per_page
        16
    end

    # POSTS
    def self.image_dimensions
        [200, 200, 10_000, 10_000] # min width, min height, max width, max height
    end

    def self.min_img_width
        image_dimensions[0]
    end

    def self.min_img_height
        image_dimensions[1]
    end

    def self.max_img_width
        image_dimensions[2]
    end

    def self.max_img_height
        image_dimensions[3]
    end

    def self.thumb_size
        '200x200'
    end

    # COMMENTS
    def max_comment_length
        500
    end
end
