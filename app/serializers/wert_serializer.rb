class WertSerializer < ActiveModel::Serializer
  # attributes :zaehler_id, :stand, :datum, :verbrauch, :x
  # attributes :stand, :datum, :x, :y, :zaehler_id
  attributes :x, :y
  attr_accessor :x, :y

  # y-Wert: Zählerstand
  def y
    object.stand
  end

  # x-Wert: Datum in millisecunden für Highchart
  def x
    object.datum.strftime('%Q').to_i
  end
  
end
