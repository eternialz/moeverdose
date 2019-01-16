class Comment < ApplicationRecord

    belongs_to :user, class_name: "User", inverse_of: :comments
    belongs_to :report_user, class_name: "User", optional: true
    belongs_to :post, class_name: "Post", inverse_of: :comments, touch: true

    alias_attribute :report?, :report

end
