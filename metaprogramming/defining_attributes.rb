class Base
  def initialize(args = {})
    return if args.nil?
    args.each do |key, value|
      validate_attribute(key)
      instance_variable_set("@#{key}", value)
    end
  end

  class << self
    def attributes_list
      @attributes_list ||= []
    end

    def attribute(attr)
      define_method(attr) { instance_variable_get("@#{attr}") }
      define_method("#{attr}=") { |val| instance_variable_set("@#{attr}", val) }
      attributes_list << attr
    end

    def attributes(*attrs)
      attrs.each do |attr|
        attribute(attr)
      end
    end
  end

  private

  def attribute_defined?(attr_name)
    self.class.attributes_list.include?(attr_name)
  end

  def validate_attribute(attr_name)
    raise ArgumentError, ":#{attr_name} is not an argument of #{self.class}!" unless attribute_defined?(attr_name)
  end
end

class Person < Base
  attributes :name, :age
end

class Animal < Base
  attributes :number, :weight
end

person = Person.new
person.name = "John Doe"
person.age = 28

puts person.name
puts person.age

animal = Animal.new(number: 123, weight: 333.22)
puts animal.weight
puts animal.number

person_2 = Person.new(name: "Henry Bricks", age: 35)
puts person_2.name
puts person_2.age

begin
  wrong_person = Person.new(name: "Johnny Bad", age: 18, message: "I don't belong here")
rescue ArgumentError => e
  puts "#{e.class}: #{e.message}"
end
