class ZaehlerSerializer < ActiveModel::Serializer
  # attributes :id, :bezeichnung, :kurzbezeichnung, :faktor
  attributes :name, :faktor
  # has_many :werte, embed: :ids, root: :data
  has_many :werte, key: :data
  # attr_accessor :name

  def name
    object.kurzbezeichnung
  end

end
