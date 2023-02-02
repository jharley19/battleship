require_relative '../models/game_board'
require_relative '../models/ship'
require_relative '../models/position'

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)
    return nil unless File.exist? path
    fiveShips = 0
    gb = GameBoard.new(10, 10)

    read_file_lines(path) { |x| 
        if x =~ /^\((10|[1-9]),(10|[1-9])\), (Right|Up|Down|Left), ([1-5])$/ then
            if fiveShips < 5
        
                pos = Position.new($1.to_i, $2.to_i)

                blackPearl = Ship.new(pos,$3,$4.to_i)

                if gb.add_ship(blackPearl) == true
                    fiveShips += 1
                end
                if fiveShips == 5
                    return gb
                end
            end
        end
    }
    
    return nil
end

# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
    return nil unless File.exist? path
    arr = Array.new
    success = 0
    read_file_lines(path) { |x| 
    if x =~ /^\((10|[1-9]),(10|[1-9])\)$/ then
        success = 1
        pos = Position.new($1.to_i, $2.to_i)
        arr.push(pos)
    end
    }
    if success == 1
        return arr
    else 
        return nil
    end
end


# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
    return false unless File.exist? path
    if block_given?
        File.open(path).each do |line|
            yield line
        end
    end
    true
end
