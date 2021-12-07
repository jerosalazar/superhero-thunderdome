require_relative './api_connection'
require_relative './hero'
require_relative './errors'
require_relative './hero_factory'

class Simulation
  GLOVES = "\u{1f94a}".freeze
  CUP = "\u{1F3C6}".freeze
  MEDAL = "\u{1F3C5}".freeze
  EXPLOTION = "\u{1f4a5}".freeze
  HOURGLASS = "\u{231b}".freeze
  MEGAPHONE = "\u{1f4e3}".freeze

  def run_tournament
    initial_message
    tournament_setup
    tournament
  end

  def initial_message
    puts GLOVES * 27
    puts wrap_message('Welcome to the Thunderdome', GLOVES)
    puts wrap_message('a deadly 5v5 match', GLOVES)
    puts wrap_message('between the bravest heroes', GLOVES)
    puts "#{GLOVES * 27}\n\n"
  end

  def set_teams
    @team1, @team2 = SuperheroFactory.new.hero_teams_brew
  end

  def tournament_setup
    puts HOURGLASS * 27
    puts wrap_message('The tournament is beggining.', HOURGLASS)
    puts wrap_message('We\'re creating the groups', HOURGLASS)
    set_teams
    puts wrap_message('The groups have been crated', HOURGLASS)
    puts "#{HOURGLASS * 27}\n\n"
    display_team(@team1)
    display_team(@team2)
  end

  def tournament
    competing_team1 = @team1.heroes.select { |hero| hero.health.positive? }
    competing_team2 = @team2.heroes.select { |hero| hero.health.positive? }
    round_count = 1
    puts MEGAPHONE * 27
    puts wrap_message('Tournament starting!', MEGAPHONE)
    puts "#{MEGAPHONE * 27}\n\n"
    while competing_team1.count.positive? && competing_team2.count.positive?
      hero1 = competing_team1.sample
      hero2 = competing_team2.sample
      puts MEGAPHONE * 27
      puts wrap_message("Round #{round_count} starting", MEGAPHONE)
      puts wrap_message("Hero 1: #{hero1.name} (#{hero1.health.to_i} hp).", MEGAPHONE)
      puts wrap_message("Hero 2: #{hero2.name} (#{hero2.health.to_i} hp).", MEGAPHONE)
      puts MEGAPHONE * 27
      round([hero1, hero2])
      competing_team1 = @team1.heroes.select { |hero| hero.health.positive? }
      competing_team2 = @team2.heroes.select { |hero| hero.health.positive? }
      round_count += 1
    end
    winning_team = competing_team1.count.positive? ? @team1 : @team2
    puts "\n#{CUP * 27}"
    puts wrap_message('The tournament has finished!', CUP)
    puts wrap_message('We have our proud winners', CUP)
    puts "#{CUP * 27}\n\n"
    puts display_team(winning_team)
  end

  def round(selected_heroes)
    # will start hero with higher speed
    selected_heroes.sort_by(&:speed)
    continue_battle = true
    first_hero_turn = true
    while continue_battle
      attacker = first_hero_turn ? selected_heroes[0] : selected_heroes[1]
      defender = first_hero_turn ? selected_heroes[1] : selected_heroes[0]
      chosen_attack = [attacker.mental_attack, attacker.strong_attack, attacker.fast_attack].sample
      puts wrap_message("#{attacker.name}'s turn", GLOVES)
      puts wrap_message("#{chosen_attack.to_i} dmg to #{defender.name} (#{defender.health.to_i} hp)", GLOVES)
      defender.health -= chosen_attack
      if defender.health <= 0
        puts wrap_message('Critical hit!', EXPLOTION)
        puts wrap_message("#{defender.name} has been defeated!", EXPLOTION)
        defender.health = 0
        continue_battle = false
      else
        puts wrap_message("#{defender.name}'s new health: #{defender.health.to_i} hp", GLOVES)
      end
      first_hero_turn = !first_hero_turn
    end
    # reset winner health
    attacker.reset_health
    puts wrap_message("#{attacker.name} is the winner", MEDAL)
  end

  def display_team(team)
    puts team.symbol * 27
    puts wrap_message('Team members:', team.symbol)
    team.heroes.each do |hero|
      puts wrap_message(" #{hero}", team.symbol)
    end
    puts "#{team.symbol * 27}\n\n"
  end

  def wrap_message(message, character)
    character * 2 + " #{message} ".center(46) + character * 2
  end
end
