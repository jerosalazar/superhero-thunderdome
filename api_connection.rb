require 'httparty'
require_relative './errors'

class SuperHeroConnectionService
  BASE_URL = 'https://superheroapi.com/api/'.freeze

  def obtain_hero(hero_id)
    response = HTTParty.get(BASE_URL + "#{ENV['SUPER_HERO_TOKEN']}/#{hero_id}")
    raw_data = JSON.parse(response.body)

    hero_info = {
      id: raw_data['id'],
      name: raw_data['name'],
      power: raw_data['powerstats']['power'],
      strength: raw_data['powerstats']['strength'],
      intelligence: raw_data['powerstats']['intelligence'],
      speed: raw_data['powerstats']['speed'],
      durability: raw_data['powerstats']['durability'],
      combat: raw_data['powerstats']['combat'],
      alignment: raw_data['biography']['alignment']
    }

    # some heroes have null stats, not usable
    check_info_integrity(hero_info)

    hero_info
  end

  def check_info_integrity(hero_info)
    hero_info.each do |_, value|
      raise InvalidHeroError, "invalid hero #{hero_info[:id]}" if value == 'null'
    end
  end
end
