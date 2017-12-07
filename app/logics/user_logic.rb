require 'delegate'

class UserLogic < SimpleDelegator

    def update_level
        self.upload_count += 1
        self.exp += 1

        if self.level.final == false && self.level.max_exp <= self.exp
            self.exp = self.exp - self.level.max_exp # Not useful when incrementing 1 by 1 but may be in the future
            self.level = Level.find_by(rank: self.level.rank + 1)
        end
        self.save
    end

end
