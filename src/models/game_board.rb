class GameBoard
    attr_reader :max_row, :max_column
    
    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column

        # hash to store ships on the gameboard
        @hashship = Hash.new
        # inc will act as the key and will be increased after one is added
        @inc = 0
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        # coord will be a 2-D array of every coordinate the ship touches
        coord = Array.new
        # attack will be an array of booleans keeping track if the
        # coorisponding coordinate in coords has been hit
        attack = Array.new
        i = 0

        # make sure the starting position is on the board
        if ship == nil || ship.start_position.column > @max_column || \
            ship.start_position.column < 1 || \
            ship.start_position.row > @max_row || \
            ship.start_position.row < 1
                return false
        end

        # add each set of coordinates into an array
        if ship.orientation.upcase == "LEFT"
            while i < ship.size
                subCoord = Array.new
                # make sure each point is on the gameboard
                if ship.start_position.column-i < 1
                    return false
                end
                subCoord.push(ship.start_position.row)
                subCoord.push(ship.start_position.column-i)
                # add point to the coordinate array
                coord.push(subCoord)
                # add a false value to the attack array
                attack.push(false)
                i += 1
            end
        elsif ship.orientation.upcase == "RIGHT"
            while i < ship.size
                subCoord = Array.new
                if ship.start_position.column+i > @max_column
                    return false
                end
                subCoord.push(ship.start_position.row)
                subCoord.push(ship.start_position.column+i)
                coord.push(subCoord)
                attack.push(false)
                i += 1
            end
        elsif ship.orientation.upcase == "UP"
            while i < ship.size
                subCoord = Array.new
                if ship.start_position.row-i < 1
                    return false
                end
                subCoord.push(ship.start_position.row-i)
                subCoord.push(ship.start_position.column)
                coord.push(subCoord)
                attack.push(false)
                i += 1
            end
        elsif ship.orientation.upcase == "DOWN"
            while i < ship.size
                subCoord = Array.new
                if ship.start_position.row+i > @max_row
                    return false
                end
                subCoord.push(ship.start_position.row+i)
                subCoord.push(ship.start_position.column)
                coord.push(subCoord)
                attack.push(false)
                i += 1
            end
        else
            return false
        end
        
        # check to see if there are overlaps on the board
        arr = @hashship.values  
        arr.each { |c|
            j = 0 
            while j < c[0].length
                k = 0
                while k < coord.length
			        if c[0][j] == coord[k]
				        return false
                    end
                    k += 1
                end
                j +=1
            end
        }
        
        # 3rd variable is a hit count
        @hashship[@inc] = coord, attack, 0
        @inc += 1
   
       return true
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)
        # check position
        if position == nil || position.row < 1 || position.row > @max_row || position.column < 1 || \
            position.column > @max_column
            return nil
        end

        pos = Array.new
        pos.push(position.row, position.column)

        arr = @hashship.values  
        arr.each { |c|
            j = 0 
            while j < c[0].length
                if c[0][j] == pos 
                    # if the position has not been hit, indicate that it is now
                    if c[1][j] == false
                        c[1][j] = true
                        c[2] += 1
                    end
                    return true
                end
            j +=1
            end
        }
        return false
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
        arr = @hashship.values
        sum = 0
        arr.each { |c|
            sum += c[2]
        }
        return sum
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
        arr = @hashship.values
        arr.each { |c|
            # if the number of hits = every ship's length
            if c[1].length != c[2]
                return false
            end
        }
        return true
    end


    # String representation of GameBoard (optional but recommended)
    def to_s
        "STRING METHOD IS NOT IMPLEMENTED"
    end
end
