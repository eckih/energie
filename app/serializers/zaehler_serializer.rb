class ZaehlerSerializer < ActiveModel::Serializer
  attributes :id, :bezeichnung, :kurzbezeichnung, :faktor
  has_many :werte
end
