class TagsController < ApplicationController
    before_action :set_tag, except: [:index]
    before_action :authenticate_user!, except: [:index]
    before_action -> { set_custom_index_values(8, [8, 32]) }, only: [:index]

    def index
        @tags = if params[:query]
                    Kaminari.paginate_array(
                        Tag.sort_by(set_sort_by)
                        .joins(:aliases).where('aliases.name LIKE ?', "%#{params[:query]}%").uniq
                    ).page(params[:page]).per(@items_per_page)
                else
                    Kaminari.paginate_array(
                        Tag.sort_by(set_sort_by)
                    ).page(params[:page]).per(@items_per_page)
                end

        title('All Tags')
        render component 'tags/index'
    end

    def edit
        @names = @tag.opt_names.map(&:to_s).join(' ')

        title('Edit tag ' + @tag.name)
        render component 'tags/edit'
    end

    def update
        # Get new aliases array without duplicates
        names = params[:names].split(' ').map { |name| TagService.sanitize name }.uniq

        aliases = [@tag.main_alias]
        names.each do |name|
            # Get alias or create a new one
            aliases.push(@tag.aliases.find_by(name: name) || Alias.new(name: name, tag_id: @tag.id))
        end

        @tag.aliases = aliases

        if @tag.save
            flash.now[:success] = "Modifications for #{@tag.names[0]} saved!"
            redirect_to tags_path
        else
            flash[:error] = 'The modifications you entered are invalid. Please verify and try again.'
            redirect_to edit_tag_path(@tag)
        end
    end

    private

    def set_tag
        @tag = Tag.includes(:aliases).find_by(id: params[:id])
    end

    def set_sort_by
        params.permit(Tag.sort_scopes).with_defaults(popular: 'desc')
    end
end
