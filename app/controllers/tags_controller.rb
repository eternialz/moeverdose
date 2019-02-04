class TagsController < ApplicationController
    before_action :set_tag, except: [:index]
    before_action :authenticate_user!, except: [:index]

    def index
        if params[:query]
          @tag = Tag.includes(:aliases).where(aliases: {name: params[:query]})
            if @tag.exists?
                redirect_to edit_tag_path(@tag[0])
            else
                flash.now[:error] = "The specified tag wasn't found"
            end
        end

        @tags = Kaminari.paginate_array(Tag.all).page(params[:page]).per(20)

        title("All Tags")
    end

    def edit
        @names = @tag.opt_names.map {|str| "#{str}"}.join(' ')

        title("Edit tag " + @tag.name)
    end

    def update
        @tag.names = params[:names].downcase.split(" ").insert(0, @tag.names[0])

        @tag.names = @tag.names.uniq # remove duplicates

        if @tag.save
            flash.now[:success] = "Modifications for #{@tag.names[0]} saved!"
            redirect_to tags_path
        else
            flash.now[:error] = "The modifications you entered are invalid. Please verify the informations and try to save again."
            redirect_to edit_tag_path(@tag)
        end
    end

    private

    def set_tag
      @tag = Tag.includes(:aliases).find_by(id: params[:id])
    end
end
