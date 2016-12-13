class Player

  COLORS = {
    blue: 44,
    red: 41
  }

  attr_reader :color, :name

  def initialize(name, color)
    @name = name
    @color = COLORS[color]
  end

  def mark
    @name[0].upcase
  end

  def pretty_mark
    string_with_color(mark, color)
  end

  def pretty_name
    string_with_color(name, color)
  end

  def string_with_color(string, color_code)
    "\e[#{color_code}m#{string}\e[0m"
  end

end
