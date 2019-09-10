class Comment < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # text: String => Comment's content
    #
    # timestamps => yes
    #
    # post: Post => Post on which the comment is posted
    # reports: Array<Report> => Reports on the comments
    # user: User => User who posted the comment
    ####################################################################

    belongs_to :user, class_name: 'User', inverse_of: :comments
    has_many :reports, as: :reportable
    belongs_to :post, class_name: 'Post', inverse_of: :comments, touch: true

    def report
        reports.count >= ConfigHelper.report_limit
    end
    alias_method :report?, :report
end
