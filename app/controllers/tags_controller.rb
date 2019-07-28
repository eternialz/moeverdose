class TagsController < ApplicationController
    before_action :set_tag, except: [:index]
    before_action :authenticate_user!, except: [:index]

    def index
        @default_per_page = 20
        @items_per_page_list = [10, 20, 40]
        @items_per_page = items_per_page()

        if params[:query]
            @tags = Kaminari.paginate_array(
                Tag.popular.joins(:aliases).where('aliases.name LIKE ?', "%#{params[:query]}%" ).uniq)
                    .page(params[:page]).per(@items_per_page)
        else
            @tags = Kaminari.paginate_array(Tag.popular).page(params[:page]).per(@items_per_page)
        end

        title("All Tags")
        render component "tags/index"
    end

    def edit
        @names = @tag.opt_names.map {|str| str.to_s}.join(' ')

        title("Edit tag " + @tag.name)
        render component "tags/edit"
    end

    def update
        # Get new aliases array without duplicates
        names = params[:names].downcase.split(" ").uniq

        if names.any?
            aliases = [@tag.main_alias]
            names.each do |name|
                # Get alias or create a new one
                aliases.push(@tag.aliases.find_by(name: name) || Alias.new({name: name, tag_id: @tag.id}))
            end

            @tag.aliases = aliases
        else
            flash.now[:error] = "You didn't provide any aliases."
        end

        if !flash.now[:error] && @tag.save
            flash.now[:success] = "Modifications for #{@tag.names[0]} saved!"
            redirect_to tags_path
        else
            flash.now[:error] ||= "The modifications you entered are invalid. Please verify the informations and try to save again."
            redirect_to edit_tag_path(@tag)
        end
    end

    private

    def set_tag
      @tag = Tag.includes(:aliases).find_by(id: params[:id])
    end
end
