json._embedded do
  json.array!(@images) do |image|
    json.extract! image, :id, :url, :source_url
    json._links do
      json.self image_url(image, format: :json)
    end
  end
end
