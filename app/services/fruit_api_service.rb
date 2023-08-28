class FruitApiService
  BASE_URL = 'https://www.fruityvice.com/api/fruit'

  # Perform a generic HTTP GET request to the Fruit API.
  # Returns a parsed JSON response.
  def self.get(resource)
    response = HTTParty.get("#{BASE_URL}/#{resource}")
    JSON.parse(response.body)
  end

  # Retrieve a fruit from the Fruit API based on a specific attribute and its value.
  #
  # @param attribute [Symbol] The attribute by which to fetch the fruit (e.g., :id, :name, etc.).
  # @param value [String] The value of the specified attribute to filter the search.
  # @return [Hash] A hash representing the fruit's information.
  def self.get_fruit(attribute, value)
    # Determine the appropriate API resource based on the attribute and value.
    resource = case attribute
               when :id, :name
                 value.to_s
               else
                 "#{attribute}/#{value}"
               end

    # Perform an API request to retrieve the fruit.
    get(resource)
  end
end
