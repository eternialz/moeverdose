class Comment
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user, class_name: "User", inverse_of: :comment

    belongs_to :post, class_name: "Post", inverse_of: :comment, touch: true

    field :text, type: String

    field :report, type: Boolean, default: false
    alias_method :report?, :report

    field :score, type: Integer

    belongs_to :report_user, class_name: "User", optional: true
    field :report_reason, type: String
end
