class Report < ApplocationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # reason: String => Why the associated item is reported
    # reportable_id: Integer=> ID of the ressouce that was reported
    # reportable_type: String => Type of ressource that was reported (post, comment, user)
    #
    # timestamps => yes
    #
    # user: User => User that made the report
    # reportable: any => Ressource that was reported
    #
    ####################################################################
    belongs_to :reportable, polymorphic: true

    belongs_to :user
end