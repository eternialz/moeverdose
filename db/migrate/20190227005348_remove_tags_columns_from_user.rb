class RemoveTagsColumnsFromUser < ActiveRecord::Migration[5.2]
    def change
        remove_column :users, :blacklisted_tags, :string
        remove_column :users, :favorites_tags, :string
    end
end
