class Zaehler < ActiveRecord::Base
  has_many :werte, :dependent => :destroy
  accepts_nested_attributes_for :werte
  belongs_to :typ
  attr_accessible :bezeichnung, :kurzbezeichnung, :lat, :lng, :nummer, :standort, :typ_id, :werte_attributes
  validates :nummer, numericality: { only_integer: true }
  validates :nummer, presence: true
  
  def nr_bez
  "#{nummer} #{kurzbezeichnung}"
  end
end
