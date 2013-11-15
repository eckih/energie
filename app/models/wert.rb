class Wert < ActiveRecord::Base
  belongs_to :zaehler
  attr_accessible :stand, :datum, :zaehler_id
  #validates :datum, presence: true
end
