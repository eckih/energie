class DataSerializer < ActiveModel::Serializer
  # attributes :zaehler_id, :stand, :datum, :verbrauch, :x
  attributes :stand #, :datum, :x, :y, :zaehler_id
end
