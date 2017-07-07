require 'delegate'

class UserLogic < SimpleDelegator
    
    def update_level
        self.upload_count += 1

        if self.level.final == false && self.level.max_exp == self.upload_count
            self.level = Level.find_by(rank: @post.user.level.rank + 1)
        end
        self.save
    end

end
