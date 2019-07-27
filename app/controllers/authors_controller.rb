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
        @old_name = @author.name

        main_alias = @author.tag.main_alias
        new_alias = @author.tag.aliases.where(name: params[:author][:name]).first || Alias.new(name: params[:author][:name].downcase.tr(' ', '_'), tag: @author.tag, main: true)

        new_alias.main, main_alias.main = true, false

        @author.assign_attributes(author_params)

        if params[:author][:name].present? && main_alias.save && new_alias.save && @author.tag && @author.save
            @author.tag.save
            flash.now[:success] = "The author was updated!"
            redirect_to author_path(@author)
        else
            flash.now[:error] = "Modifications could not be saved! Please verify informations provided"
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
