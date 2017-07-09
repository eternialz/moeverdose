module ConfigHelper
    # GENERAL
    def site_name
        "Moeverdose"
    end

    def chat_url
        "https://discord.me/moeverdose"
    end

    def twitter_url
        "https://twitter.com/moeverdose"
    end

    # POSTS
    def self.image_dimensions
        [200, 200, 10000, 10000] # min width, min height, max width, max height
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
        "200x200"
    end

    # COMMENTS
    def max_comment_length
        500
    end
end
