class TagsController < ApplicationController
    before_action :set_tag, except: [:index]
    before_action :authenticate_user!

    def index
        @tags = Tag.all
    end

    def edit
        @names = @tag.names[1..-1].map {|str| "#{str}"}.join(' ')
    end

    def update
        @tag.names = params[:names].downcase.split(" ").insert(0, @tag.names[0])

        @tag.names = @tag.names.uniq # remove duplicates

        if @tag.save
            flash[:success] = "Modifications for #{@tag.names[0]} saved!"
            redirect_to tags_path
        else
            flash[:error] = "The modifications you entered are invalid. Please verify the informations and try to save again."
            edit
        end
    end

    private

    def set_tag
        @tag = Tag.find_by(id: params[:id])
    end
end
