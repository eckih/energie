class Typ < ActiveRecord::Base
  has_many :zaehlers
  attr_accessible :bezeichnung, :link
end
