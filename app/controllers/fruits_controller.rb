class FruitsController < ApplicationController
  BASE_URL = 'https://www.fruityvice.com/api/fruit'
  CRITERIA_MAPPING = {
    id: :get_fruit,
    name: :get_fruit,
    family: :get_fruit,
    genus: :get_fruit,
    order: :get_fruit
  }.freeze

  def index; end

  def export_csv
    criteria = {
      id: params[:fruit_id],
      name: params[:name],
      family: params[:family],
      genus: params[:genus],
      order: params[:order]
    }

    fruits = fetch_fruits_by_criteria(criteria)

    filename = params[:filename].presence || 'fruits'
    headers = %w[name id family genus order nutritions]

    send_data generate_csv(fruits, headers),
              type: 'text/csv; charset=utf-8; header=present',
              disposition: "attachment; filename=#{filename}.csv"
  end

  private

  # Fetch fruits based on the specified criteria.
  # If no criteria are selected, retrieve all fruits.
  def fetch_fruits_by_criteria(criteria)
    chosen_criteria = criteria.select { |_, value| value.present? }
    if chosen_criteria.empty?
      FruitApiService.get('all')
    else
      method_name = CRITERIA_MAPPING[chosen_criteria.keys.first]
      [FruitApiService.send(method_name, chosen_criteria.keys.first, chosen_criteria.values.first)].flatten
    end
  end

  # Generate a CSV representation of the provided data with headers.
  def generate_csv(data, headers)
    CSV.generate(headers: true) do |csv|
      csv << headers

      data.each do |fruit|
        csv << fruit.values_at(*headers)
      end
    end
  end
end
