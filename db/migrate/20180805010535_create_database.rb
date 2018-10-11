class CreateDatabase < ActiveRecord::Migration[5.2]
    def change
        change_table :users do |t|
            t.string :name
            t.text :biography
            t.string :website
            t.string :twitter
            t.string :facebook
            t.integer :upload_count
            t.integer :exp
            t.boolean :report
            t.boolean :banned
            t.string :role
            t.string :favorites_tags
            t.string :blacklisted_tags
        end

        create_table :news do |t|
            t.string :title
            t.text :text
            t.timestamps
        end

        create_table :levels do |t|
            t.string :name
            t.integer :rank, default: 0
            t.boolean :final, default: false
            t.integer :max_exp
            t.string :color, default: '#1AB'
            t.timestamps
        end
        add_reference :users, :level, {to_table: :levels}

        create_table :posts do |t|
            t.string :md5
            t.integer :height
            t.integer :width
            t.integer :overdose
            t.integer :moe_shortage
            t.string :title
            t.string :source
            t.text :description
            t.boolean :report
            t.text :report_reason
            t.timestamps
        end
        add_reference :posts, :user, {to_table: :users}
        add_reference :posts, :report_user, {to_table: :users}

        create_table :aliases do |t|
            t.string :name
            t.boolean :main, default: false
        end

        create_table :tags do |t|
            t.string :type
            t.integer :posts_count
            t.timestamps
        end

        add_reference :aliases, :tag, {to_table: :tags}
        create_join_table :posts, :tags

        create_table :comments do |t|
            t.text :text
            t.boolean :report
            t.text :report_reason
            t.timestamps
        end

        add_reference :comments, :user, {to_table: :users}
        add_reference :comments, :report_user, {to_table: :users}
        add_reference :comments, :post, {to_table: :posts}

        create_table :authors do |t|
            t.string :name
            t.text :biography
            t.string :website
            t.timestamps
        end

        add_reference :authors, :tag, {to_table: :tags}
        add_reference :posts, :author, {to_table: :authors}

    end
end
