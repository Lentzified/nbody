require 'gosu'
require_relative "z_order"

class Planet

	GRAVITY = 6.67408e-11
	DT = 25000

	attr_accessor :x, :y, :x_vel, :y_vel, :mass, :image, :image_file, :x_acc, :y_acc
	def initialize(x, y, x_vel, y_vel, mass, image, size_of_simulation)
		@mass = mass
		@image = Gosu::Image.new("images/#{image}", tileable: true)
		@image_file = image
		@size_of_simulation = size_of_simulation
		@x = x
		@y = y
		@x_vel = x_vel
		@y_vel = y_vel
		@x_acc = x_acc
		@y_acc = y_acc
	end

	def warp(x, y)
		@x, @y = x, y
	end

	def draw
		@image.draw_rot((@x * 320 / @size_of_simulation) + 320, (@y * 320 / @size_of_simulation) + 320, 1, 0)
	end

	def calculate_force(planet)
		d_x = planet.x - @x
		d_y = planet.y - @y
		#puts "self: " + image_file + " other: " + planet.image_file
		#puts d_x
		#puts d_y
		r = Math.sqrt(d_x ** 2 + d_y ** 2)
		#puts r
		f = (GRAVITY * @mass * planet.mass) / r ** 2
		#puts f
		f_x = f * (d_x / r)
		f_y = f * (d_y / r)
		#puts f_x
		#puts f_y
		return [f_x, f_y]
	end

	def calculate_acceleration(f_x, f_y)
		@x_acc = f_x / @mass 
		@y_acc = f_y / @mass
	end

	def calculate_velocity
		@x_vel += @x_acc * DT
		@y_vel += @y_acc * DT
	end

	def move
		@x += @x_vel * DT
		@y += @y_vel * DT
	end

	def x_pos
		@x
	end

	def y_pos
		@y
	end
end