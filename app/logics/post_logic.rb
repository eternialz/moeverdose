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

end
