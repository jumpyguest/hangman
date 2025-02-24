# THIS FILE IS NOT USED
require 'json'

module BasicSerializeable
  @@serializer = JSON

  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
      # p obj[var]
    end

    # File.open('hangman.txt', 'w') { |file| file.puts(@@serializer.dump obj) }
    # puts "saved to hangman.txt"
    p @@serializer.dump obj
  end

  def unserialize(string)
    # stream = File.read('hangman.txt')
    obj = @@serializer.parse(string)
    obj.keys.each do |key|
      instance_variable_set(key, obj[key])
    end
  end
end