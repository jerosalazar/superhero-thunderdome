require_relative './api_connection'
require_relative './hero'
require_relative './errors'

class SuperheroFactory
  NUMBER_OF_CHARACTERS = 731
  DIAMOND = "\u{1F48E}".freeze
  FLOWER = "\u{1f4ae}".freeze

  def single_brew
    random_hero_id = rand(1..NUMBER_OF_CHARACTERS)
    raise ExistingIdError, "existing id #{random_hero_id}" if existing_ids.include? random_hero_id

    hero_information = hero_api_connection.obtain_hero(random_hero_id)
    existing_ids << random_hero_id
    Hero.new(hero_information)
  rescue InvalidHeroError, ExistingIdError => e
    puts "#{e}. Calling another hero"
    retry
  end

  def hero_teams_brew
    teams = []
    team_symbols = [DIAMOND, FLOWER]
    2.times do |team_index|
      current_team = []
      5.times do
        current_team << single_brew
      end
      teams << Team.new(current_team, team_symbols[team_index])
    end
    teams
  end

  private

  def hero_api_connection
    @hero_api_connection ||= SuperHeroConnectionService.new
  end

  def existing_ids
    @existing_ids ||= []
  end
end
