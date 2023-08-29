class FruitsController < ApplicationController
  def index; end

  def export_csv
    criteria = {
      id: params[:fruit_id],
      name: params[:name],
      family: params[:family],
      genus: params[:genus],
      order: params[:order],
      type: params[:type],
      min: params[:min],
      max: params[:max]
    }

    fruits = fetch_fruits_by_criteria(criteria)

    filename = params[:filename].presence || 'fruits'
    headers = %w[name id family genus order nutritions]

    send_data generate_csv(fruits, headers),
              type: 'text/csv; charset=utf-8; header=present',
              disposition: "attachment; filename=#{filename}.csv"
  end

  private

  def fetch_fruits_by_criteria(criteria)
    chosen_criteria = criteria.select { |_, value| value.present? }
    if chosen_criteria.empty?
      FruitApiService.fetch_all_fruits # returns body of response with all fruits
    else
      if chosen_criteria.key?(:family) and chosen_criteria.key?(:genus)
        FruitApiService.fetch_fruits_w_family_n_genus(chosen_criteria[:family], chosen_criteria[:genus])
      elsif chosen_criteria.key?(:type) and chosen_criteria.key?(:min) and chosen_criteria.key?(:max)
        [FruitApiService.fetch_fruits_by_protein_range(chosen_criteria[:type],chosen_criteria[:min], chosen_criteria[:max])].flatten
      else
        [FruitApiService.fetch_fruits_with_criteria(chosen_criteria)].flatten
      end
    end
  end

  def generate_csv(data, headers)
    CSV.generate(headers: true) do |csv|
      csv << headers

      data.each do |fruit|
        csv << fruit.values_at(*headers)
      end
    end
  end
end
