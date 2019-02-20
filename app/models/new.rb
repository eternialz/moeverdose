class New < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # title: String => Self exp
    # text: String => New's content
    #
    # timestamps => yes
    ####################################################################

    validates :title, presence: true
    validates :text, presence: true

end
