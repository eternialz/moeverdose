class DiscordBot
    include Rails.application.routes.url_helpers

    def run
        require 'discordrb'
        prefix = "$"

        bot = Discordrb::Commands::CommandBot.new token: ENV["DISCORD_BOT_USER_TOKEN"], client_id: ENV["DISCORD_CLIENT_ID"].to_i, prefix: prefix

        bot.command :help do |event|
            commands = [
                prefix + "help          : get this help list\n",
                prefix + "post id       : get the link of the post you specified\n",
                prefix + "random        : get the link of a random post\n",
                prefix + "poke          : Yada!\n",
                prefix + "user username : get the link of a moeverdose account\n"
            ]
            event.respond "```" + commands.join('') + "```"
        end

        bot.command :post do |event, id|
            post_url(id: id)
        end

        bot.command :user do |event, id|
            user_url(id: id)
        end

        bot.command :poke do |event|
            "Yamete kudasai! #{event.user.username}-senpai!"
        end

        bot.command :random do |event|
            post_url(id: Post.all.sample.number)
        end

        bot.run :async
    end
end

