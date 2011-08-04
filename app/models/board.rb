class Board < ActiveRecord::Base
  belongs_to :game
  
  attr_accessor :board_data
  attr_accessor :board_content
  attr_accessor :playedWords
  
  require 'rexml/document'
  include REXML
  
  after_initialize :load_board
  
  def load_board()
    @board_data = Hash.new()
    someXML = Document.new(self.content)
    someXML.elements.each("board/tiles/tile") do |tile|
      x = tile.attributes["x"]
      y = tile.attributes["y"]
      unless (@board_data.has_key?(x))
        @board_data[x.to_s] = Hash.new("foo")
      end
      @board_data[x.to_s][y.to_s] = tile
    end
    @playedWords = self.played_words
  end
  
  def init()
    @board_data = Hash.new()
    someXML = Document.new(self.content)
    someXML.elements.each("board/tiles/tile") do |tile|
      x = tile.attributes["x"]
      y = tile.attributes["y"]
      unless (@board_data.has_key?(x))
        @board_data[x.to_s] = Hash.new("foo")
      end
      @board_data[x.to_s][y.to_s] = tile
    end
  end
  
  def get_played_words
    played_words_hash = Hash.new()
    #someXML = Document.new(self.played_words)
    #someXML.elements.each("scoreEvent") do |score|
    #  played_words_hash[score.attributes["turn"]] = Hash.new
    #  played_words_hash[score.attributes["turn"]]["word"] = score.attributes["word"]
    #end
    if @playedWords.nil?
      return played_words_hash
    end
    @playedWords.split("\n").each_with_index do |words, i|
      played_words_hash[i] = words
    end
    return played_words_hash
  end
  
  def get_spot(x, y)
    if @board_data.has_key?(x)
      if (@board_data[x].has_key?(y))
        t =  Element.new(@board_data[x][y])
        t.attributes["game_id"] = self.game_id
        t.attributes["board_id"] = id
        return t
      end
    end
  end
  
  def print_content
    board = Document.new()
    board.add_element("board")
    board.root.add_element("tiles")
    tiles = board.root.elements[1]
    @board_data.keys.each do |x|
      @board_data[x].keys.each do |y|
        tile = get_spot(x, y)
        tiles.add_element(tile)
      end
    end
    board.to_s
  end
  
  def set_tile(x, y, state, score, letter)
    tile = get_spot(x, y)
    tile.attributes["letter"] = letter
    tile.attributes["state"] = state
    tile.attributes["score"] = score
    @board_data[x.to_s][y.to_s] = tile  
  end
def default_board_xml
  board = Document.new()
  board.add_element("board")
  board.root.add_element("tiles")
  tiles = board.root.elements[1]
  
  (0..8).each do |x|
    (0..8).each do |y|
      tile = Element.new("tile")
      tile.add_attribute("x",x)
      tile.add_attribute("y",y)
      tile.add_attribute("state", "HIDDEN")
      tile.add_attribute("letter", "?")
      if (x == 4 and y == 4)
        tile.attributes["state"] = "PANDA"
      end
      
      if (x == 3 and y == 3)
        tile.attributes["state"] = "OPEN"
        tile.attributes["letter"] = "?"
        tile.attributes["score"] = 5
      end
      if (x == 4 and y == 3)
        tile.attributes["state"] = "OPEN"
        tile.attributes["letter"] = "?"
        tile.attributes["score"] = 5
      end
      if (x == 5 and y == 3)
        tile.attributes["state"] = "OPEN"
        tile.attributes["letter"] = "?"
        tile.attributes["score"] = 5
      end
      if (x == 3 and y == 5)
        tile.attributes["state"] = "OPEN"
        tile.attributes["letter"] = "?"
        tile.attributes["score"] = 5
      end
      if (x == 4 and y == 5)
        tile.attributes["state"] = "OPEN"
        tile.attributes["letter"] = "?"
        tile.attributes["score"] = 5
      end
      if (x == 5 and y == 5)
        tile.attributes["state"] = "OPEN"
        tile.attributes["letter"] = "?"
        tile.attributes["score"] = 5
      end
      if (x == 3 and y == 4)
        tile.attributes["state"] = "OPEN"
        tile.attributes["letter"] = "?"
        tile.attributes["score"] = 5
      end
      if (x == 5 and y == 4)
        tile.attributes["state"] = "OPEN"
        tile.attributes["letter"] = "?"
        tile.attributes["score"] = 5
      end
      tiles.add_element(tile)
    end
  end
  #board.root.add_element(tiles)
  board.to_s
end
end
