class AddForeignKeyConstaints < ActiveRecord::Migration[6.0]
	def change
        add_foreign_key :users, :levels, column: :level_id, on_delete: :nullify
        add_foreign_key :posts, :users, column: :user_id, on_delete: :nullify
        add_foreign_key :aliases, :tags, column: :tag_id, on_delete: :cascade
        add_foreign_key :comments, :users, column: :user_id, on_delete: :nullify
        add_foreign_key :comments, :posts, column: :post_id, on_delete: :nullify
        add_foreign_key :authors, :tags, column: :tag_id, on_delete: :nullify
        add_foreign_key :posts, :authors, column: :author_id, on_delete: :nullify
        add_foreign_key :permissions, :users, column: :user_id, on_delete: :cascade
		add_foreign_key :permissions, :permissions_types, column: :permissions_type_id, on_delete: :cascade
		add_foreign_key 'blacklisted_tags_users', :users, column: :user_id, on_delete: :cascade
		add_foreign_key 'blacklisted_tags_users', :tags, column: :tag_id, on_delete: :cascade
		add_foreign_key 'disliked_posts_users', :users, column: :user_id, on_delete: :cascade
		add_foreign_key 'disliked_posts_users', :posts, column: :post_id, on_delete: :cascade
		add_foreign_key 'favorites_posts_users', :users, column: :user_id, on_delete: :cascade
		add_foreign_key 'favorites_posts_users', :posts, column: :post_id, on_delete: :cascade
		add_foreign_key 'favorites_tags_users', :users, column: :user_id, on_delete: :cascade
		add_foreign_key 'favorites_tags_users', :tags, column: :tag_id, on_delete: :cascade
		add_foreign_key 'liked_posts_users', :users, column: :user_id, on_delete: :cascade
		add_foreign_key 'liked_posts_users', :posts, column: :post_id, on_delete: :cascade
		add_foreign_key 'posts_tags', :tags, column: :tag_id, on_delete: :cascade
		add_foreign_key 'posts_tags', :posts, column: :post_id, on_delete: :cascade
  	end
end
