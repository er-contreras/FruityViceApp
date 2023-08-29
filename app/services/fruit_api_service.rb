class FruitApiService
  BASE_URL = 'https://www.fruityvice.com/api/fruit'

  def self.fetch_all_fruits
    perform_get('all')
  end

  def self.fetch_fruits_with_criteria(criteria)
    attribute, value = criteria.first
    perform_get(api_resource(attribute, value))
  end

  def self.fetch_fruits_w_family_n_genus(family, genus)
    family_fruits = perform_get(api_resource(:family, family))
    matching_fruits = family_fruits.select { |fruit| fruit['genus'] == genus }
    matching_fruits
  end

  def self.fetch_fruits_by_protein_range(type, min, max)
    perform_get("#{type}?min=#{min}&max=#{max}")
  end

  private

  def self.api_resource(attribute, value)
    case attribute
    when :id, :name
      value.to_s
    else
      "#{attribute}/#{value}"
    end
  end

  def self.perform_get(resource)
    response = HTTParty.get("#{BASE_URL}/#{resource}")
    JSON.parse(response.body)
  rescue HTTParty::Error, JSON::ParserError, StandardError => e
    # Handle errors appropriately, e.g., log and handle gracefully.
    Rails.logger.error("FruitApiService error: #{e.message}")
    []
  end
end
