class FruitsController < ApplicationController
  BASE_URL = 'https://www.fruityvice.com/api/fruit'

  def index
  end

  def export_csv
    fruit_id = params[:fruit_id]
    fruit_name = params[:name]
    fruit_family = params[:family]
    fruit_genus = params[:genus]
    fruit_order = params[:order]

    if fruit_id.present?
      fruits = [get_fruit_by_id(fruit_id)]
    elsif fruit_family.present? && fruit_genus.present?
      fruits = get_fruit_by_family(fruit_family).select { |fruit| fruit['genus'] == fruit_genus }
    elsif fruit_name.present?
      fruits = [get_fruit_by_name(fruit_name)]
    elsif fruit_family.present?
      fruits = get_fruit_by_family(fruit_family)
    elsif fruit_genus.present?
      fruits = get_fruit_by_genus(fruit_genus)
    elsif fruit_order.present?
      fruits = get_fruit_by_order(fruit_order)
    else
      fruits = get_fruits
    end

    filename = params[:filename] != "" ? params[:filename] : 'fruits'
    headers = %w[name id family genus order nutritions]

    send_data generate_csv(fruits, headers),
              type: 'text/csv; charset=utf-8; header=present',
              disposition: "attachment; filename=#{filename}.csv"
  end

  private

  def get_fruit_by_id(id)
    url = "#{BASE_URL}/#{id}"
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end

  def get_fruit_by_name(name)
    url = "#{BASE_URL}/#{name}"
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end

  def get_fruit_by_family(family)
    url = "#{BASE_URL}/family/#{family}"
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end

  def get_fruit_by_genus(genus)
    url = "#{BASE_URL}/genus/#{genus}"
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end

  def get_fruit_by_order(order)
    url = "#{BASE_URL}/order/#{order}"
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end

  def get_fruits
    url = "#{BASE_URL}/all"
    response = HTTParty.get(url)
    JSON.parse(response.body)
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
