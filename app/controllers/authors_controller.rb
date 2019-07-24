class AuthorsController < ApplicationController
    require 'uri'

    before_action :set_author, except: [:index]
    before_action :authenticate_user!, only: [:update, :edit]

    def index
        @default_per_page = 20
        @items_per_page_list = [10, 20, 40]
        @items_per_page = items_per_page()

        if params[:query]
            @authors = Kaminari.paginate_array(
                Author.includes(:tag).all.where('name LIKE ?', "%#{params[:query]}%" ))
                .page(params[:page]).per(@items_per_page)
        else
            @authors = Kaminari.paginate_array(Author.includes(:tag).all.order(:name => 'asc')).page(params[:page]).per(@items_per_page)
        end


        title("All Authors")
        render component "authors/index"
    end

    def show
        @posts = Kaminari.paginate_array(Post.where(author: @author)).page(params[:page]).per(items_per_page())

        @tag = @author.tag
        @names = @tag.names
        @website = @author.website

        title(@author.name + "'s author page")
        render component "authors/show"
    end

    def edit
        @website = @author.website

        title("Edit " + @author.name + "'s author page")
        render component "authors/edit"
    end

    def update
        new_name = params[:author][:name]
        main_alias = Alias.where(tag: @author.tag, main: true).first

        if @author.name != new_name
            existing_alias = @author.tag.aliases.where(name: new_name).first
            main_alias.update_attributes(main: false)
            if existing_alias.present?
                existing_alias.update_attributes(main: true)
            else
                Alias.create(name: new_name.downcase.tr(' ', '_'), tag: @author.tag, main: true)
            end
        end

        @saved_website = @author.website
        @author.assign_attributes(author_params)

        if flash.now[:error] == nil && @author.save && @author.tag.save
            flash.now[:success] = "The author page was updated!"
            redirect_to author_path(@author)
        else
            flash.now[:error] = "Modifications could not be saved! Please verify informations provided"
            @website = @saved_website
            render component "authors/edit"
        end
    end

    private
    def set_author
        @author = Author.find(params[:id])
    end

    def author_params
        params.require(:author).permit(
            :name, :biography, :website
        )
    end
end
