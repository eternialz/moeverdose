class Comment < ApplicationRecord

    belongs_to :user, class_name: "User", inverse_of: :comment

    belongs_to :post, class_name: "Post", inverse_of: :comment, touch: true

    field :text, type: String

    field :report, type: Boolean, default: false
    alias_method :report?, :report

    belongs_to :report_user, class_name: "User", optional: true
    field :report_reason, type: String
end
