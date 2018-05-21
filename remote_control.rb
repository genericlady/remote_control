class Command
  attr_reader :receiver

  def initialize(receiver=nil)
    @receiver = receiver
  end

  def execute
    if receiver.nil?
      raise "Must be initialized with a object that responds to #execute."
    else
      raise NoMethodError, "You must define behavior for #execute"
    end
  end 
end

class NoCommand
  attr_reader :slot

  def initialize(slot)
    @slot = slot
  end

  def self.create(total_no_commands=1)
    total_no_commands
      .times
      .map { |idx| self.new(idx) }
  end

  def execute
    begin
      raise NoMethodError
    rescue
      puts "There is no command for slot ##{slot}"
    end
  end
end

class StereoOnWithCDCommand < Command
  def execute
    receiver.off
  end
end

class StereoOffWithCDCommand < Command
  def execute
    receiver.off
  end
end


class LightOffCommand < Command
  def execute
    receiver.off
  end
end

class LightOnCommand < Command
  def execute
    receiver.on
  end
end

class StereoOnWithCDCommand < Command
  attr_accessor :cd, :volume

  def initialize(receiver)
    super
    @cd = ''
    @volume = 11
  end

  def execute
    receiver.on
  end
end

class StereoOffWithCDCommand < Command
  def execute
    receiver.off
  end
end

# class RoomName
#   attr_reader :name
# 
#   def initialize(name)
#     @name = name
#   end
# end
#

class RoomName < Struct.new(:name)
end

class Light < RoomName
  def on
    puts "The #{name} light is on"
  end

  def off
    puts "The #{name} light is off"
  end
end

class CeilingFan < RoomName
  def on
    puts "The #{name} light is on"
  end

  def off
    puts "The #{name} light is off"
  end
end

class GarageDoor < RoomName
  def up
    puts "The Garage Door is up"
  end

  def down
    puts "The Garage Door is down"
  end
end

class Stereo < RoomName
  def on
    puts "The Stereo in the #{name} is on"
  end

  def off
    puts "The Stereo in the #{name} is off"
  end
end

class CeilingFanOn < Command
  def execute
    receiver.on
  end
end

class CeilingFanOff < Command
  def execute
    receiver.off
  end
end

class GarageDoorUp < Command
  def execute
    receiver.up
  end
end

class GarageDoorDown < Command
  def execute
    receiver.down
  end
end

class LightOnCommand < Command
  def execute
    receiver.on
  end
end

class LightOnCommand < Command
  def execute
    receiver.on
  end
end

class RemoteControl
  MAX_COMMANDS = 7

  attr_accessor :on_commands, :off_commands

  def initialize
    @on_commands = NoCommand.create(MAX_COMMANDS)
    @off_commands = NoCommand.create(MAX_COMMANDS)
  end

  def add_command(slot, on_command, off_command)
    on_commands[slot] = on_command
    off_commands[slot] = off_command
  end

  def on_button_was_pushed(slot)
    on_commands[slot].execute
  end

  def off_button_was_pushed(slot)
    off_commands[slot].execute
  end

  def to_s
    "\n------------Remote Control------------\n" +
      MAX_COMMANDS.times.map do |command_index|
      "slot ##{command_index} - on command: #{on_commands[command_index].class.to_s}, " +
        "off command: #{off_commands[command_index].class.to_s}"
      end.join("\n")
  end

  def print
    puts self.to_s
  end
end

module RemoteLoader
  def self.run
    remote_control = RemoteControl.new

    living_room_light = Light.new("Living Room")
    kitchen_light = Light.new("Kitchen")
    ceiling_fan = CeilingFan.new("Living Room")
    garage_door = GarageDoor.new("")
    stereo = Stereo.new("Living Room")

    living_room_light_on = LightOnCommand.new(living_room_light)
    living_room_light_off = LightOffCommand.new(living_room_light)
    kitchen_light_on = LightOnCommand.new(kitchen_light)
    kitchen_light_off = LightOffCommand.new(kitchen_light)

    ceiling_fan_on = CeilingFanOn.new(ceiling_fan)
    ceiling_fan_off = CeilingFanOff.new(ceiling_fan)

    garage_door_up = GarageDoorUp.new(garage_door)
    garage_door_down = GarageDoorDown.new(garage_door)

    stereo_on_with_cd = StereoOnWithCDCommand.new(stereo)
    stereo_off_with_cd = StereoOffWithCDCommand.new(stereo)

    remote_control.add_command(0, living_room_light_on, living_room_light_off)
    remote_control.add_command(1, kitchen_light_on, kitchen_light_off)
    remote_control.add_command(2, ceiling_fan_on, ceiling_fan_off)
    remote_control.add_command(3, stereo_on_with_cd, stereo_off_with_cd)
    remote_control.add_command(4, garage_door_up, garage_door_down)

    remote_control.print

    remote_control.on_button_was_pushed(0)
    remote_control.off_button_was_pushed(0)
    remote_control.on_button_was_pushed(1)
    remote_control.off_button_was_pushed(1)
    remote_control.on_button_was_pushed(2)
    remote_control.off_button_was_pushed(2)
    remote_control.on_button_was_pushed(3)
    remote_control.off_button_was_pushed(3)
    remote_control.on_button_was_pushed(4)
    remote_control.off_button_was_pushed(4)
  end
end

RemoteLoader.run
