require 'pry'
class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  # Initialize with send
  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  # Create student instance from each hash of input array
  def self.create_from_collection(students_array)
    students_array.each do |student|
      student = Student.new({
        :name => student[:name],
        :location => student[:location],
        :profile_url => student[:profile_url]  
      })
    end
  end

  # Add student attributes from profile page hash
  def add_student_attributes(attributes_hash)
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
    self
  end

  # @all reader
  def self.all
    @@all
  end
end