json.property do
  json.extract! @property, :id, :content
  json.label @property.label, :id, :status
end