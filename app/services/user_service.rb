class UserService
    def self.update_level(user)
        user.upload_count += 1
        user.exp += 1

        if user.level.final == false && user.level.max_exp <= user.exp
            user.exp = user.exp - user.level.max_exp # Not useful when incrementing 1 by 1 but may be in the future
            user.level = Level.find_by(rank: user.level.rank + 1)
        end
        user.save
    end

end
