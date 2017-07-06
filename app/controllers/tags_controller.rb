class TagsController < ApplicationController
    before_action :set_tag
    before_action :authenticate_user!

    def index
        @tags = Tag.all
    end

    def edit
        @names = @tag.names[1..-1].map {|str| "#{str}"}.join(' ')
    end

    def update
        @tag.names = params[:names].downcase.split(" ").insert(0, @tag.names[0])

        @tag.save
    end

    private

    def set_tag
        @tag = Tag.find_by(id: params[:id])
    end
end
