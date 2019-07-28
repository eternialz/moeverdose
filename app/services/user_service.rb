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

    def self.get_personal_infos(name)
        user = User.includes({ favorites_tags: :aliases }, { blacklisted_tags: :aliases },
                { permissions: :permissions_type }, :comments, :favorites, :liked_posts, :disliked_posts
                ).find_by(name: name)
        user.to_json(only: [
                :email, :current_sign_in_ip, :last_sign_in_ip, :name, :biography,
                :website, :twitter, :facebook, :upload_count, :exp
            ], include: {
                comments: { only: :text },
                favorites: { only: :id },
                liked_posts: { only: :id },
                disliked_posts: { only: :id },
                favorites_tags: {
                    only: :id,
                    include: { aliases: { only: :name }}
                },
                blacklisted_tags: {
                    only: :id,
                    include: { aliases: { only: :name }}
                },
                permissions: {
                    only: :consent,
                    include: {
                        permissions_type: { only: [:name, :description] }
                    }
                },
            }
        )
    end
end
