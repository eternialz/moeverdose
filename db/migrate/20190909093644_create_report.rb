class CreateReport < ActiveRecord::Migration[6.0]
    def change
        create_table :reports do |t|
            t.text :reason
            t.references :reportable, polymorphic: true

            t.timestamps
        end

        add_reference :reports, :user, to_table: :users
        add_foreign_key :reports, :users, column: :user_id, on_delete: :nullify
    end
end
