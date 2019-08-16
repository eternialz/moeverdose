class AuthorsController < ApplicationController
    require 'uri'

    before_action :set_author, except: [:index]
    before_action :set_default_index_values, only: [:index]
    before_action :authenticate_user!, only: [:update, :edit]

    def index
        @authors = if params[:query]
                       Kaminari.paginate_array(
                           Author.sort_by(set_sort_by).includes(:tag).all.where('name LIKE ?', "%#{params[:query]}%")
                       ).page(params[:page]).per(@items_per_page)
                   else
                       Kaminari.paginate_array(
                           Author.sort_by(set_sort_by).includes(:tag).all
                       ).page(params[:page]).per(@items_per_page)
                   end

        title('All Authors')
        render component 'authors/index'
    end

    def show
        @posts = Kaminari.paginate_array(
            Post.sort_by(set_post_sort_by).where(author: @author)
        ).page(params[:page]).per(items_per_page)

        @tag = @author.tag
        @names = @tag.names
        @website = @author.website

        title(@author.name + "'s author page")
        render component 'authors/show'
    end

    def edit
        title('Edit ' + @author.name + "'s author page")
        render component 'authors/edit'
    end

    def update
        @old_name = @author.name

        main_alias = @author.tag.main_alias
        new_alias = @author.tag.aliases.where(name: params[:author][:name]).first
        new_alias ||= Alias.new(
            name: TagService.sanitize(params[:author][:name]),
            tag: @author.tag,
            main: true
        )

        new_alias.main = true
        main_alias.main = false

        @author.assign_attributes(author_params)

        if params[:author][:name].present? && main_alias.save && new_alias.save && @author.tag && @author.save
            @author.tag.save
            flash.now[:success] = 'The author was updated!'
            redirect_to author_path(@author)
        else
            flash.now[:error] = 'Modifications could not be saved! Please verify informations provided'
            render component 'authors/edit'
        end
    end

    private

    def set_author
        @author = Author.find(params[:id])
    end

    def set_sort_by
        params.permit(Author.sort_scopes).with_defaults(alphabetical: 'desc')
    end

    def set_post_sort_by
        params.permit(Post.sort_scopes).with_defaults(created_at: 'desc')
    end

    def author_params
        params.require(:author).permit(
            :name, :biography, :website
        )
    end
end
