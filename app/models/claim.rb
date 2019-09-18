class Claim < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # post: Post => claimed post
    # user: User => User who made the claim
    # status : String => The current state of the claim
    ####################################################################

    belongs_to :post, class_name: 'Post', inverse_of: :claims
    validates_presence_of :post

    belongs_to :user, class_name: 'User', inverse_of: :claims
    validates_presence_of :user

    module Status
        ################################################################
        # open: unresolved claim -> post is hidden
        # accepted: uploader accepted claim -> post is hidden
        # dismissed: uploader refused claim -> post is shown again
        # canceled: claimer canceled the claim from an open or acepted state -> post is shown again
        ################################################################
        def self.all
            ['open', 'accepted', 'dismissed', 'canceled']
        end

        def self.hide_post
            ['open', 'accepted']
        end

        all.each do |status|
            define_method("#{status}?") do
                self.status == status
            end
        end
    end
    include Claim::Status
    validates :status, inclusion: { in: Claim::Status.all }

    def hide_post?
        Claim::Status.hide_post.include? status
    end
end
