require "gosu"
require "./planet.rb"
require_relative "z_order"

class NbodySimulation < Gosu::Window

  def initialize
    super(640, 640, false)
    self.caption = "NBody simulation"
    @background_image = Gosu::Image.new("images/space.jpg", tileable: true)

    get_planets()

  end

  def update
    @planets.each do |planet|
      f_x = 0
      f_y = 0

      @planets.each do |other_planet|
        if other_planet != planet
          forces = planet.calculate_force(other_planet)
          f_x = forces[0]
          f_y = forces[1]
          planet.calculate_acceleration(f_x, f_y)
          planet.calculate_velocity
        end
      end

    end
    @planets.each do |planet|
      planet.move
    end
  end

  def get_planets()

    filename = ARGV.first
    txt = File.open("simulations/#{filename}").read
    @planet_count = nil
    @planets = []
    @radius = nil
    line_num = 0
    txt.each_line do |line|
      if line_num == 0
        @planet_count = line.to_i
      elsif line_num == 1
        @radius = line.to_f
      elsif line_num >= 2 && line_num <= 1 + @planet_count
        array = line.split(' ')

        x = array[0].to_f
        y = array[1].to_f  
        x_vel = array[2].to_f
        y_vel = array[3].to_f
        mass = array[4].to_f
        image = array[5]

        @planets.push(Planet.new(x, y, x_vel, y_vel, mass, image, @radius))
      end

      line_num += 1
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @planets.each do |planet|
      planet.draw
    end
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end
  
end

window = NbodySimulation.new
window.show