class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions_types do |t|
        t.string :name
        t.text :description

        t.timestamps
    end

    create_table :permissions do |t|
        t.boolean :consent

        t.timestamps
    end
    add_reference :permissions, :user, {to_table: :users}
    add_reference :permissions, :permissions_type, {to_table: :permissions_types}
  end
end
