require 'delegate'

class UserLogic < SimpleDelegator

    def update_level
        self.upload_count += 1
        self.exp += 1

        if self.level.final == false && self.level.max_exp == self.upload_count
            self.level = Level.find_by(rank: self.level.rank + 1)
            self.exp = 0
        end
        self.save
    end

end
