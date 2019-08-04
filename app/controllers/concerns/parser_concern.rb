module ParserConcern
    extend ActiveSupport::Concern

    include ActionView::Helpers::UrlHelper

    def scan_for_post(text)
        posts = text.scan(/\#[0-9]+/) # matches #number

        posts.each do |post|
            link = '<span>#</span>' + link_to(post[1..-1], post_path(Integer(post[1..-1])))

            text.sub! post, link
        end

        text
    end

    def scan_for_user(text)
        users = text.scan(/\@[a-zA-Z0-9]+/) # matches @username

        users.each do |user|
            link = '<span>@</span>' + link_to(user[1..-1], user_path(id: user[1..-1]))

            text.sub! user, link
        end

        text
    end

    def scan_for_comment(text)
        comments = text.scan(/\$[0-9]+/) # matches $number

        comments.each do |comment|
            link = '<span>$</span>' + link_to(comment[1..-1], '#comment_' + comment[1..-1])

            text.sub! comment, link
        end

        text
    end

    def scan_for_spoiler(text)
        spoilers = text.scan(%r{\[spoiler\].+?\[/spoiler\]}) # matches $number

        spoilers.each do |spoiler|
            spoil = '<label class="spoiler-toggle" title="Click to display">Spoiler<input type="checkbox"><span class="spoiler">' + spoiler[9..-11] + '</span></label>'

            text.sub! spoiler, spoil
        end

        text
    end
end
