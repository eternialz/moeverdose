class Alias < ApplicationRecord
    ####################################################################
    # PROPERTIES: TYPE => PURPOSE
    # ----------------------------
    # name: String => Self exp
    # main: Boolean => true if the alias is the main alias of tag
    #
    # timestamps => no
    #
    # tag: Tag => Self exp
    ####################################################################
    validates :name, uniqueness: { scope: :tag_id }
    validates :name, presence: true
    validates :main, uniqueness: { scope: :tag_id }, if: :main

    belongs_to :tag, optional: true
end
