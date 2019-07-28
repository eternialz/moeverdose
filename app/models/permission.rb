class Permission < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # consent: Boolean => Can we make the processing
    #
    # timestamps => yes
    #
    # user: User => On who can we make the processing
    # permissions_type: PermissionsType => What process can we use on this process
    ####################################################################

    belongs_to :user
    belongs_to :permissions_type
end
