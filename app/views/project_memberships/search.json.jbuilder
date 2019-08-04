json.array!(@members) do |member|
  json.name     member[0]
  json.id       member[1]
end
