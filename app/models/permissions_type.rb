class PermissionsType < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # name: String => Name of the processing
    # description: String => Processing type description
    #
    # timestamps => yes
    #
    # permissions: Array<Permission> => All permissions of this type
    ####################################################################
    has_many :permissions
end
