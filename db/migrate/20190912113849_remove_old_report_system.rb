class RemoveOldReportSystem < ActiveRecord::Migration[6.0]
    def change
        remove_column :users, :report, :boolean
        remove_column :comments, :report, :boolean
        remove_column :posts, :report, :boolean
        remove_column :comments, :report_reason, :text
        remove_column :comments, :report_user_id, :bigint
        remove_column :posts, :report_reason, :text
        remove_column :posts, :report_user_id, :bigint
    end
end
