require 'delegate'

class PostLogic < SimpleDelegator
    def get_different_tags
        characters = []
        authors = []
        tags = []
        self.tags.each do |tag|
            if tag.content?
                tags << tag.name
            elsif tag.character?
                characters << tag.name
            elsif tag.author?
                authors << tag.name
            end
        end
        return {tags: tags, characters: characters, authors: authors}

    end
end
