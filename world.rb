# The following classes represent the world of the game -

class World
  @rooms
  @characters

  def initialize(world_file)
    @rooms = Hash.new
    @characters = Array.new

    file = File.read(world_file).split(/^\#/).drop(1).each do |chunk|
      room = chunk.split(/\r?\n|\r/)
      new_room = Room.new

      room_number = room.shift.to_i
      new_room.name = room.shift[0..-2]

      new_room.description = room.shift
      line = room.shift
      while line != "~"
        new_room.description.concat("\n")
        new_room.description.concat(line)
        line = room.shift
      end

      line = room.shift
      line = room.shift

      while line != "S"
        if line[0] == "D"
          direction = line[1]
          dest = room.shift
          while dest != "~"
            dest = room.shift
          end
          room.shift
          dest = room.shift.split[-1]
          new_room.direction_data.store(direction.to_i, dest.to_i)
          line = room.shift
        else
          while line != "~"
            line = room.shift
          end
          line = room.shift
        end
      end
      @rooms[room_number] = new_room
      #puts line
    end
  end

  def get_room_name(room_number)
    return @rooms.key?(room_number) ? @rooms[room_number].name : nil
  end

  def get_room_description(room_number)
    return @rooms.key?(room_number) ? @rooms[room_number].description : nil
  end

  def get_destination(room_number, direction)
    return @rooms.key?(room_number) && @rooms.key?(@rooms[room_number].direction_data[direction]) ? @rooms[room_number].direction_data[direction] : nil
  end

end

class DescriptionData
  @keyword
  @description
end

class Room
  attr_accessor :number, :name, :description, :extra_descriptions, :direction_data, :room_flags, :light, :characters

  #@contents

  def initialize
    @direction_data = Hash.new
  end

end
