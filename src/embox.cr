enum Side
  North
  South
  East
  West

  def self.horizontal : Set(Side)
    Set{East, West}
  end

  def self.vertical : Set(Side)
    Set{North, South}
  end

  def self.all : Set(Side)
    Set{North, South, East, West}
  end
end

def box(sides : Set(Side)) : String
  return "\u{253c}" if sides == Set{Side::North, Side::South, Side::East, Side::West}

  return "\u{2500}" if sides == Side.horizontal
  return "\u{2502}" if sides == Side.vertical

  return "\u{250c}" if sides == Set{Side::South, Side::East}
  return "\u{2510}" if sides == Set{Side::South, Side::West}
  return "\u{2514}" if sides == Set{Side::North, Side::East}
  return "\u{2518}" if sides == Set{Side::North, Side::West}

  return "\u{251c}" if sides == Set{Side::North, Side::South, Side::East}
  return "\u{2524}" if sides == Set{Side::North, Side::South, Side::West}
  return "\u{252c}" if sides == Set{Side::South, Side::East, Side::West}
  return "\u{2534}" if sides == Set{Side::North, Side::East, Side::West}

  raise ArgumentError.new(sides.inspect)
end

def print_all
  (2..4).each do |s|
    Side.all.to_a.combinations(s).map(&.to_set).each do |side_set|
      puts(box_drawing_character_for(side_set) + "   " + side_set.inspect)
    end
  end
end

def space
  " "
end

struct Set(T)
  def box : String
    {% if T != Side %}
      {% raise "Set(T)#box is forbidden except where T == Side" %}
    {% end %}

    box(self)
  end
end

# ------------------

class Embox
  property debug = false
  property margin = 1
  property left_margin_over : Int32?
  property right_margin_over : Int32?

  # the space betwen the arrow's point and the text
  property arrow_margin = 1

  # the number of horizontal-only characters of the arrow
  # (the arrow also has a 90deg and a triangle character)
  property arrow_length = 2

  def left_margin
    left_margin_over || margin
  end

  def right_margin
    right_margin_over || margin
  end

  def main_simple
    input = STDIN.gets_to_end.lines

    max_width = input.max_by(&.size).size

    print box(Set{Side::South, Side::East})
    print box(Side.horizontal) * left_margin
    print box(Side.horizontal) * max_width
    print box(Side.horizontal) * right_margin
    print box(Set{Side::South, Side::West})
    puts

    input.each do |line|
      extra = max_width - line.size

      print box(Side.vertical)
      print space * left_margin
      print line
      print space * extra
      print space * right_margin
      print box(Side.vertical)
      puts
    end

    print box(Set{Side::North, Side::East})
    print box(Side.horizontal) * left_margin
    print box(Side.horizontal) * max_width
    print box(Side.horizontal) * right_margin
    print box(Set{Side::North, Side::West})
    puts
  end

  def main_title
    body = STDIN.gets_to_end.lines

    title = body.shift
    title_width = title.size
    body_width = body.max_by(&.size).size

    # hat
    print box(Set{Side::South, Side::East})
    print box(Side.horizontal) * left_margin
    print box(Side.horizontal) * title_width
    print box(Side.horizontal) * right_margin
    print box(Set{Side::South, Side::West})
    puts

    # title contents
    print box(Side.vertical)
    print space * left_margin
    print title
    print space * right_margin
    print box(Side.vertical)
    puts

    # belt
    if title_width == body_width
      print box(Side.vertical.add(Side::East))
      print box(Side.horizontal) * left_margin
      print box(Side.horizontal) * body_width
      print box(Side.horizontal) * right_margin
      print box(Set{Side::South, Side::North, Side::West})
      puts
    elsif title_width < body_width
      print box(Side.vertical.add(Side::East))
      print box(Side.horizontal) * left_margin
      print box(Side.horizontal) * title_width
      print box(Side.horizontal) * right_margin
      print box(Set{Side::North, Side::East, Side::West})
      print box(Side.horizontal) * (body_width - title_width - 1)
      print box(Set{Side::South, Side::West})
      puts
    else
      print box(Side.vertical.add(Side::East))
      print box(Side.horizontal) * left_margin
      print box(Side.horizontal) * body_width
      print box(Side.horizontal) * right_margin
      print box(Set{Side::South, Side::East, Side::West})
      print box(Side.horizontal) * (title_width - body_width - 1)
      print box(Set{Side::North, Side::West})
      puts
    end

    # body contents
    body.each do |line|
      extra = body_width - line.size

      print box(Side.vertical)
      print space * left_margin
      print line
      print space * extra
      print space * right_margin
      print box(Side.vertical)
      puts
    end

    # shoes
    print box(Set{Side::North, Side::East})
    print box(Side.horizontal) * left_margin
    print box(Side.horizontal) * body_width
    print box(Side.horizontal) * right_margin
    print box(Set{Side::North, Side::West})
    puts
  end

  def main_fancy_arrow
    input = STDIN.gets_to_end.lines

    max_width = input.max_by(&.size).size

    print box(Set{Side::South, Side::East})
    print box(Side.horizontal) * left_margin
    print box(Side.vertical)
    print box(Side.horizontal) * (max_width + 1 + arrow_length + arrow_margin)
    print box(Side.horizontal) * right_margin
    print box(Set{Side::South, Side::West})
    puts

    input.each_with_index do |line, index|
      extra = max_width - line.size

      print box(Side.vertical)

      print space * left_margin
      if index == 0
        print box(Set{Side::North, Side::East})
        print box(Side.horizontal) * arrow_length
        print "►"
        print space * (arrow_margin)
      else
        print space * (2 + arrow_length + arrow_margin)
      end
      print line
      print space * extra
      print space * right_margin
      print box(Side.vertical)
      puts
    end

    print box(Set{Side::North, Side::East})
    print box(Side.horizontal) * left_margin
    print box(Side.horizontal) * (max_width + 2 + arrow_length + arrow_margin)
    print box(Side.horizontal) * right_margin
    print box(Set{Side::North, Side::West})
    puts
  end

  def parse_positive_int(name, &block)
    subarg = ARGV.shift
    if i = subarg.to_i?
      if i >= 0
        debputs "setting #{name} to #{i}"
        yield i
      else
        errputs "#{name} cannot be less than 0"
      end
    else
      errputs "#{name} argument must be an integer"
    end
  end

  def parse_cli
    main_variation = :simple

    while !ARGV.empty?
      case arg = ARGV.shift
      when "--title"
        main_variation = :title
      when "--fancy-arrow"
        main_variation = :fancy_arrow
      when "--debug"
        @debug = true
        debputs "setting debug to true"
      when "--margin"
        parse_positive_int("margin") { |i| @margin = i }
      when "--arrow-margin"
        parse_positive_int("arrow-margin") { |i| @arrow_margin = i }
      when "--arrow-length"
        parse_positive_int("arrow-length") { |i| @arrow_length = i }
      when "--left-margin"
        parse_positive_int("left-margin") { |i| @left_margin_over = i }
      when "--right-margin"
        parse_positive_int("right-margin") { |i| @right_margin_over = i }
      else
        errputs "unknown option: '#{arg}'. ignoring."
      end
    end

    case main_variation
    when :simple      then main_simple
    when :title       then main_title
    when :fancy_arrow then main_fancy_arrow
    else                   do_help
    end
  end

  # # outputs

  def outputs(any)
    STDOUT.puts(any)
  end

  def errputs(any)
    STDERR.puts(any)
  end

  def debputs(any)
    if @debug
      STDERR.puts(any)
    end
  end

  def do_help
    outputs "wrong"
  end
end

Embox.new.parse_cli
