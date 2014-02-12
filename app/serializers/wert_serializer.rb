class WertSerializer < ActiveModel::Serializer
  # attributes :zaehler_id, :stand, :datum, :verbrauch, :x
  attributes :stand, :datum, :x, :y, :zaehler_id
  attr_accessor :x, :y
end
