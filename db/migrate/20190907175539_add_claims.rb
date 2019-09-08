class AddClaims < ActiveRecord::Migration[5.2]
    def change
        create_table :claims do |t|
            t.boolean :closed

            t.timestamps
        end

        add_reference :claims, :post, to_table: :posts
        add_reference :claims, :user, to_table: :users
    end
end
