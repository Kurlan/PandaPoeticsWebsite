class BoardsController < ApplicationController
 
  require 'rexml/document'
  include REXML

  

  
  def index
    @boards = Board.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @board }
    end
  end
  
  def new
    @game = Game.find(params[:game_id])
    @board = @game.boards.create
    redirect_to game_path(@game)
  end
  
  def show
    @game = Game.find(params[:game_id])
    @game_board = Board.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_board }
    end
  end
  
  def edit
    @game = Game.find(params[:game_id])
    @game_board = Board.find(params[:id])
  end

  def update
    @game_board = Board.find(params[:id])
    @game = Game.find(params[:game_id])
    respond_to do |format|
      if @game_board.update_attributes(params[:board])
        format.html { redirect_to(game_board_path(@game, @game_board), :notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def reset
    @game_board = Board.find(params[:id])
    @game = Game.find(params[:game_id])
    @game_board.content = default_board_xml
    @game_board.save!
    respond_to do |format|
      format.html { redirect_to(game_board_path(@game, @game_board), :notice => 'Board was reset.') }
      format.xml  { render :xml => @game_board }
    end
  end
  
  def edit_tile
    @game_board = Board.find(params[:id])
    @game = Game.find(params[:game_id])
    @recs = Array.new
    recsXML = Document.new(@game_board.recommendations)
    @recsByWord = Hash.new
    @allRecs = Array.new
    recsXML.elements.each("recs/rec") do |r|
      word = r.attributes["word"]
      rank = r.attributes["rank"]
      unless (@recsByWord.has_key?(word))
        @recsByWord[word] = Hash.new
        @recsByWord[word]["count"] = 0
        @recsByWord[word]["rank"] = rank
      end
      @recsByWord[word]["count"] += 1
      @recsByWord[word]["rank"] = [rank,@recsByWord[word]["rank"]].min
      spotData = ""
      total_score=0;
      panda_score=0;
      word_score = 0;
      r.elements.each("score") do |score|
        total_score = score.attributes["total"].to_i;
      end
      r.elements.each("spot") do |s|
        spotData += s.attributes["x"] + s.attributes["y"]+'-'
      end
      spotData += "#{word}-#{total_score}" ;
      unless (@recsByWord[word].has_key?("recs"))

        @recsByWord[word]["recs"] = Array.new
      end
      @recsByWord[word]["recs"].push(spotData)

    end
    @orderedKeys = @recsByWord.keys
    @orderedKeys.sort! { |x,y| @recsByWord[x]["rank"] <=> @recsByWord[y]["rank"] }
    
  end
  
  def update_tile
    @x = params[:x]
    @y = params[:y]
    @state = params[:state]
    @score = params[:score]
    @letter = params[:letter]
    @game_board = Board.find(params[:id])
    @game = Game.find(params[:game_id])
    @game_board.set_tile(@x, @y, @state, @score, @letter)
    @game_board.content = @game_board.print_content
    @game_board.save!
    respond_to do |format|
      format.html { redirect_to(game_path(@game), :notice => "Tile was altered.") }
    end
  end
  
  def get_recs
    @game_board = Board.find(params[:id])
    @game = Game.find(params[:game_id])
    myStr = ""
    (0..8).each do |x|
      (0..8).each do |y|
        tile = @game_board.get_spot(x.to_s,y.to_s)
        score = tile.attributes["score"]
        if score.nil?
          score = 0
        end
        myStr += "#{tile.attributes["letter"]},#{score} "
      end
      myStr += "\n"
    end
    unless @game_board.played_words.nil?
      myStr += "#{@game_board.played_words}\n"
    end
    filename = "/Users/steve/Documents/workspace/PandaPoetics/PandaPoetics/data/board-#{params[:id]}"
    aFile = File.new(filename, "w")
    aFile.write(myStr)
    aFile.close

    recsXML = `java -jar /Users/steve/Documents/workspace/PandaPoeticsWebsite/PandaPoetics/app/Solver.jar '#{filename}'`
    @game_board.recommendations = recsXML
    @game_board.save!
    respond_to do |format|
      format.html { redirect_to(edit_tile_path(@game, @game_board), :notice => "Recs were added.") }
    end

     
  end
  
  def take_turn
    @selected_turn = params[:selected_turn]
    @game_board = Board.find(params[:id])
    @game = Game.find(params[:game_id])
    @game_board.save!
    

    myStr = ""
        (0..8).each do |x|
          (0..8).each do |y|
            tile = @game_board.get_spot(x.to_s,y.to_s)
            score = tile.attributes["score"]
            if score.nil?
              score = 0
            end
            myStr += "#{tile.attributes["letter"]},#{score} "
          end
          myStr += "\n"
        end
        myStr += "#{@selected_turn}\n"
        filename = "/Users/steve/Documents/workspace/PandaPoetics/PandaPoetics/data/board-#{params[:id]}"
        aFile = File.new(filename, "w")
        aFile.write(myStr)
        aFile.close
    
        recsXML = `java -jar /Users/steve/Documents/workspace/PandaPoeticsWebsite/PandaPoetics/app/Solver.jar '#{filename}'`
    someXML = Document.new(recsXML)
    
    @newBoard = Board.new;

    @newBoard.content = someXML.elements["recs/board"].to_s
    puts @newBoard.content.to_s
    @newBoard.game_id = @game.id
    if @game_board.played_words.nil?
      @newBoard.played_words = "#{@selected_turn}"
    else
      @newBoard.played_words = "#{@game_board.played_words}|#{@selected_turn}"
    end
    @newBoard.save!
    @game.current_board = @newBoard.id;
    @game.save!
    respond_to do |format|
      format.html { redirect_to(game_path(@game), :notice => "#{@selected_turn}") }
    end

  end
  
  
end
