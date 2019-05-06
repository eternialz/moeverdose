class Comment < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # text: String => Comment's content
    # report: Boolean => true: comment reported
    # report_reason: String => Why is the comment reported
    #
    # timestamps => yes
    #
    # post: Post => Post on which the comment is posted
    # report_user: User => User who reported the comment
    # user: User => User who posted the comment
    ####################################################################

    belongs_to :user, class_name: "User", inverse_of: :comments
    belongs_to :report_user, class_name: "User", optional: true
    belongs_to :post, class_name: "Post", inverse_of: :comments, touch: true

    alias_attribute :report?, :report

end
