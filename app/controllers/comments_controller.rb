class CommentsController < ApplicationController
    include ActionView::Helpers::UrlHelper

    before_action :set_post
    before_action :authenticate_user!

    def create
        @comment = Comment.create(params.require(:comment).permit(:text))
        length = @comment.text.length

        if length > 1 and length < 500
            @comment.text = scan_comment(@comment.text) # This can add to the length, so validations are not used

            @comment.user = current_user
            @post.comments << @comment
            @comment.post = @post

            if @post.save && @comment.save
                flash[:success] = "Comment added."
            else
                flash[:error] = "Comment invalid."
            end
        else
            flash[:error] = "Comment invalid: please verify the length."
        end

        redirect_to post_path(@post.number)
    end

    def report
        @comment = Comment.find(params[:comment_id])
        @comment.report = true
        @comment.report_user = current_user
        @comment.save
        redirect_to post_path(@post.number)
    end

    private

    def set_post
        @post = Post.find_by(number: params[:post_id])
    end

    def scan_comment(text) # scan for comments, posts, and users referenced in comments
        text = scan_for_post(text)
        text = scan_for_user(text)
        text = scan_for_comment(text)
        text = scan_for_spoiler(text)
        return text
    end

    def scan_for_post(text)
        posts = text.scan(/\#[0-9]+/) # matches #number

        posts.each do |post|
            link = '<span>#</span>' + link_to(post[1..-1], post_path(Integer(post[1..-1])))

            text.sub! post, link
        end

        return text
    end

    def scan_for_user(text)
        users = text.scan(/\@[a-zA-Z0-9]+/) # matches @username

        users.each do |user|
            link = '<span>@</span>' + link_to(user[1..-1], user_path(id: user[1..-1]))

            text.sub! user, link
        end

        return text
    end

    def scan_for_comment(text)
        comments = text.scan(/\$[0-9]+/) # matches $number

        comments.each do |comment|
            link = '<span>$</span>' + link_to(comment[1..-1], '#comment_' + comment[1..-1])

            text.sub! comment, link
        end

        return text
    end

    def scan_for_spoiler(text)
        spoilers = text.scan(/\[spoiler\].+?\[\/spoiler\]/) # matches $number

        spoilers.each do |spoiler|
            spoil = '<span class="spoiler">' + spoiler[9..-11] + '</span>'

            text.sub! spoiler, spoil
        end

        return text
    end
end
