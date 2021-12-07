class Hero
  attr_accessor :name, :alignment, :filiation_coefficient, :speed, :health

  def initialize(hero_information)
    @id = hero_information[:id].to_f
    @name = hero_information[:name]
    @strength = hero_information[:strength].to_f
    @power = hero_information[:power].to_f
    @durability = hero_information[:durability].to_f
    @speed = hero_information[:speed].to_f
    @combat = hero_information[:combat].to_f
    @intelligence = hero_information[:intelligence].to_f
    @actual_stamina = rand(0..10).to_f
    @alignment = hero_information[:alignment]
    @filiation_coefficient = nil
    @health = reset_health
  end

  def to_s
    "#{@name} (#{@health.to_i} hp)"
  end

  def reset_health
    @health = ((((@strength * 0.8 + @durability * 0.7 + @power) / 2.0) * (1 + @actual_stamina / 10)).floor + 100).to_f
  end

  def mental_attack
    @mental_attack ||= (@intelligence * 0.7 + @speed * 0.2 + @combat * 0.1) * @filiation_coefficient
  end

  def strong_attack
    @strong_attack ||= (@strength * 0.6 + @power * 0.2 + @combat * 0.2) * @filiation_coefficient
  end

  def fast_attack
    @fast_attack ||= (@speed * 0.55 + @durability * 0.25 + @strength * 0.2) * @filiation_coefficient
  end

  def update_stats
    @strength = ((2 * @strength + @actual_stamina) * @filiation_coefficient / 1.1).floor
    @power = ((2 * @power + @actual_stamina) * @filiation_coefficient / 1.1).floor
    @durability = ((2 * @durability + @actual_stamina) * @filiation_coefficient / 1.1).floor
    @speed = ((2 * @speed + @actual_stamina) * @filiation_coefficient / 1.1).floor
    @combat = ((2 * @combat + @actual_stamina) * @filiation_coefficient / 1.1).floor
    @intelligence = ((2 * @intelligence + @actual_stamina) * @filiation_coefficient / 1.1).floor
  end
end

class Team
  attr_accessor :heroes, :team_alignment, :symbol

  def initialize(heroes, symbol)
    @heroes = heroes
    @symbol = symbol
    calculate_alignment
    calculate_filiations_and_update
  end

  def calculate_alignment
    alignments = Hash.new(0)
    @heroes.each do |hero|
      alignments[hero.alignment] += 1
    end
    @team_alignment = alignments.key(alignments.values.max)
  end

  def calculate_filiations_and_update
    @heroes.each do |hero|
      initial_coefficient = rand(1..10).to_f
      hero.filiation_coefficient = hero.alignment == @team_alignment ? initial_coefficient : 1 / initial_coefficient
      hero.update_stats
    end
  end
end
