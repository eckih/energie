class Typbez < ActiveRecord::Base
    has_many :zaehlers
  attr_accessible :bezeichnung, :kurzbezeichnung
  
  def kurz_lang
  "#{kurzbezeichnung} #{bezeichnung}"
  end
end
