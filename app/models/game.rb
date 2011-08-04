class Game < ActiveRecord::Base
  require 'rexml/document'
  include REXML
  attr_accessor :boards
  has_many :boards
  accepts_nested_attributes_for :boards


  
#  def after_initialize
#    boardContent = content
#    @board = Hash.new(" ");
#    doc = Document.new(boardContent)
#    root = doc.root
#    root.each_element('//spot') do |spot|
#      row = Hash.new(" ")
#      row[spot.attributes["y"]] = spot
#      @board[spot.attributes["x"]] = row
#    end  
#  end
#
#  def getSpot(x, y)
#    if (@board.has_key?(x)) 
#      row = @board[x]
#      if(row.has_key?(y) )
#        return row[y].elements["letter"].text 
#      end
#    end
#
#    "-"
#  end
#
#  def getKeys
#    @board.keys.join(",")
#  end

  def boardSize
    9
  end

end
