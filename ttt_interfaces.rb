# A note about comments -- 
# this is more commented than typical because
# the demo is meant to show how pseudo-code
# becomes Ruby code.
# Many of these comments should be deleted.

# Note about Privacy: We haven't made things
# private here which should be (which is 
# basically everything except `play`) in order
# to show off writing tests for those methods.
class TicTacToe

    # play
    def play

        # loop infinitely
        loop do
            # call the board rendering method
            @board.render
            # ask for coordinates from the current player
            @current_player.get_coordinates

            # check if game is over
            break if check_game_over

            # switch players
            switch_players
        end
    end

    private_class_method
    # initialize
    def initialize
        # set up the board
        @board = Board.new

        # set up the players
        @player_x = Player.new("Madame X", :x, @board)
        @player_y = Player.new("Mister Y", :y, @board)

        # assign the starting player
        @current_player = @player_x
    end



    private
    # check_game_over?
    def check_game_over
        # check for victory
        # check for draw
        check_victory || check_draw
    end


    # check_victory?
    def check_victory
        # IF Board says current player's piece has
        # a winning_combination?
        if @board.winning_combination?(@current_player.piece)
            # then output a victory message
            puts "Congratulations #{@current_player.name}, you win!"
            true
        else
            false
        end
    end


    # check_draw?
    def check_draw
        # If Board says we've filled up 
        if @board.full?
            # display draw message
            puts "Bummer, you've drawn..."
            true
        else
            false
        end
    end


    # switch_players
    def switch_players
        if @current_player == @player_x
            @current_player = @player_y
        else
            @current_player = @player_x
        end
    end

end




# Manages all player-related functionality
class Player
    attr_reader :name, :piece, :board

    # initialize
    def initialize(name = "Mystery_Player", piece, board)
        # Set marker type (e.g. X or O)
        raise "Piece must be a Symbol!" unless piece.is_a?(Symbol)
        @name = name
        @piece = piece
        @board = board
    end

    # get_coordinates
    def get_coordinates
        # loop infinitely
        loop do
            # ask_for_coordinates
            coords = ask_for_coordinates

            # IF validate_coordinates_format is true
            if validate_coordinates_format(coords)
                # IF piece can be placed on Board
                if @board.add_piece(coords, @piece)
                    # break the loop
                    break
                end
            end
        end
    end

    private
    # ask_for_coordinates
    def ask_for_coordinates
        # Display message asking for coordinates
        puts "#{@name}(#{@piece}), enter your coordinates in the form x,y:"
        # pull coordinates from command line
        gets.strip.split(",").map(&:to_i)
    end

    # validate_coordinates_format
    def validate_coordinates_format(coords)
        # UNLESS coordinates are in the proper format
        if coords.is_a?(Array) && coords.size == 2
            true
        else
            # display error message
            # Note that returning `nil` acts falsy!
            puts "Your coordinates are in the improper format!"
        end
    end

end




# Maintains game board state
class Board

    # Allow reading the @board_arr variable
    attr_reader :board_arr

    # initialize board
    def initialize( board_arr = nil )
        # set up blank data structure unless
        # we are passed one
        @board_arr = board_arr || Array.new(3){Array.new(3)}
    end

    # render
    def render
        puts
        # loop through data structure
        @board_arr.each do |row|
            row.each do |cell|
                # display an existing marker if any, else blank
                cell.nil? ? print("-") : print(cell.to_s)
            end
            puts
        end
        puts

    end

    # add_piece
    def add_piece(coords, piece)
        # IF piece_location_valid?
        if piece_location_valid?(coords)
            # place piece
            @board_arr[coords[0]][coords[1]] = piece
            true
        else
            false
        end
    end

    # winning_combination?
    def winning_combination?(piece)
        # is there a winning_diagonal?
        # or winning_vertical? 
        # or winning_horizontal? for that piece?
        winning_diagonal?(piece)   || 
        winning_horizontal?(piece) || 
        winning_vertical?(piece)
    end

    # full?
    def full?
        # does every square contain a piece?
        @board_arr.all? do |row|
            row.none?(&:nil?)
        end
    end


    private
        # piece_location_valid?
    def piece_location_valid?(coords)
        # Is the placement within_valid_coordinates?
        if within_valid_coordinates?(coords)
            # Are the piece coordinates_available?
            coordinates_available?(coords)
        end
    end

    # within_valid_coordinates?
    def within_valid_coordinates?(coords)
        # UNLESS piece coords are in the acceptible range
        if (0..2).include?(coords[0]) && (0..2).include?(coords[1])
            true
        else
            # display an error message
            puts "Piece coordinates are out of bounds"
        end
    end

    # coordinates_available?
    def coordinates_available?(coords)
        # UNLESS piece coords are not occupied
        if @board_arr[coords[0]][coords[1]].nil?
            true
        else
            # display error message
            puts "There is already a piece there!"
        end
    end
    # winning_diagonal?
    def winning_diagonal?(piece)
        # check if specified piece has a triplet across diagonals
        diagonals.any? do |diag|
            diag.all?{|cell| cell == piece }
        end
    end

    # winning_vertical?
    def winning_vertical?(piece)
        # check if specified piece has a triplet across verticals
        verticals.any? do |vert|
            vert.all?{|cell| cell == piece }
        end
    end

    # winning_horizontal?
    def winning_horizontal?(piece)
        # check if specified piece has a triplet across horizontals
        horizontals.any? do |horz|
            horz.all?{|cell| cell == piece }
        end
    end

    # diagonals
    def diagonals
        # return the diagonal pieces
        [[ @board_arr[0][0],@board_arr[1][1],@board_arr[2][2] ],[ @board_arr[2][0],@board_arr[1][1],@board_arr[0][2] ]]
    end

    # verticals
    def verticals
        # return the vertical pieces
        verticals = []
        3.times do |i|
            verticals << [@board_arr[0][i],@board_arr[1][i],@board_arr[2][i]]
        end
        verticals
    end

    # horizontals
    def horizontals
        # return the horizontal pieces
        @board_arr
    end


end

# Script to run the game on load
# t = TicTacToe.new
# t.play