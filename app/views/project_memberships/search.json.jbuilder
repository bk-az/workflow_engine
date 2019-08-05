json.array!(@search_results) do |result|
  json.display_value     result[0]
  json.id                result[1]
end
