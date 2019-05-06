class Level < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # name: String => Self exp
    # rank: Integer => Level number
    # final: Boolean => Is the last level?
    # max_exp: Integer => Threshold experience to go to the next level
    # color: String => color in hexa format for the level
    #
    # timestamps => yes
    #
    # users: Array<User> => User with the current level
    ####################################################################
    has_many :users, inverse_of: :level

    # Identification
    validates :rank, uniqueness: true

    # Data
    validates :final, uniqueness: true, if: :final?
    alias_attribute :final?, :final
end
