class Claim < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # post: Post => claimed post
    # user: User => User who made the claim
    # closed : Boolean => if the claim was closed or not
    ####################################################################

    belongs_to :post, class_name: 'Post', inverse_of: :claims
    belongs_to :user, class_name: 'User', inverse_of: :claims

    alias_attribute :closed?, :closed
end
