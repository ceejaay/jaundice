class Map
  def initialize(window, file,  player, exxit)
    @window = window
    @tile = Gosu::Image.load_tiles("media/map_tile.png", 30, 30)
    @lines = File.readlines(file).map {|line| line.chomp}
    @width = @lines[0].length
    @height = @lines.length
    @text = Gosu::Font.new(15)
    @player = player
    @visited = []
    #@exit = {tile: 1, x: 300, y: 300}
    @exit = exxit
  end

  def solid?(player_x, player_y)
    @height.times do |y|
      @width.times do |x|
      return true if @lines[y][x] == "#" and (x == player_x/30 and y == player_y/30)
      end
    end
    false
  end

  def player_at_exit?
    [@player.x, @player.y] == [@exit[:x], @exit[:y]]
  end
# we check for tiles that are in range. then we add them to the visited array.
  def visited_tiles
    @height.times do |y|
      @width.times do |x|
        if @lines[y][x] == "#"
          distance = Gosu.distance(x * 30, y * 30, @player.x, @player.y)
          exit_distance = Gosu.distance(x * 30, y * 30, @exit[:x], @exit[:y])
          if (30..60).include?(distance)
#this doesn't seem great. I'm putting tile data into a hash then using the hash to draw from in the draw method
            @visited << {tile: 0, x: x * 30, y: y * 30 }
          elsif (60..120).include?(distance)
            @visited << {tile: 2, x: x * 30, y: y * 30}
          end
          if (30..60).include?(exit_distance)
            @visited << @exit
          end
        end
      end
    end
  end
# only draws the tiles in the visited array. And the exit tile.
  def draw
    @visited.each do |tile_data|
      @tile[tile_data[:tile]].draw(tile_data[:x], tile_data[:y], 1)
      #@tile[@exit[:tile]].draw(@exit[:x], @exit[:y], 1)
    end
  end
end
