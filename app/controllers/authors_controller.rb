class AuthorsController < ApplicationController
    require 'uri'

    before_action :set_author, except: [:index]
    before_action :authenticate_user!, only: [:update, :edit]

    def index
        @authors = Kaminari.paginate_array(Author.includes(:tag).all.order_by(:name => 'asc')).page(params[:page]).per(20)

        title("All Authors")
    end

    def show
        @posts = Kaminari.paginate_array(Post.where(author: @author)).page(params[:page]).per(20)

        @tag = @author.tag

        @names = @tag.names

        @websites = @author.websites

        title(@author.name + "'s author page")
    end

    def edit
        @websites = @author.websites.join("\n")

        title("Edit " + @author.name + "'s author page")
    end

    def update
        new_name = params[:author][:name]

        if @author.name != new_name
            index = @author.tag.names.find_index(new_name)

            @author.tag.names << @author.tag.names[0]

            if index
                @author.tag.names[0] = @author.tag.names.delete_at(index)
            else
                @author.tag.names[0] = new_name
            end
        end

        @author.assign_attributes(author_params)

        @author.websites = params[:websites].split(" ")

        @author.websites.each do |url|
            unless url =~ URI::DEFAULT_PARSER.make_regexp
                flash.now[:error] = "Modifications could not be saved! Please verify website(s) url provided"
            end
        end

        if flash.now[:error] == nil && @author.save
            flash.now[:success] = "The author page was updated!"
            redirect_to author_path(@author)
        else
            flash.now[:error] = "Modifications could not be saved! Please verify informations provided"

            @websites = @author.websites.join("\n")
            render "authors/edit"
        end
    end

    private
    def set_author
        @author = Author.find(params[:id])
    end

    def author_params
        params.require(:author).permit(
            :name ,:websites, :biography
        )
    end
end
