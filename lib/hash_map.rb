# frozen_string_literal: true

require_relative 'linked_list'
require_relative 'node'

# hash map class
class HashMap
  attr_accessor :load_factor, :capacity, :codes

  @load_factor = 0.75

  @capacity = 16
  @codes = {}

  # hashing methods
  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def string_to_number(string)
    hash_code = 0
    string.each_char { |char| hash_code += char.ord }
    hash_code
  end

  # set methods
  def easy_set(key, value)
    hash_code = hash(key)
    @codes[hash_code][key.to_s] = value
  end

  def set(key, value)
    hash_code = hash(key)
    new_node = Node.new(key, value)

    hash_length = length
    @capacity += capacity if hash_length >= (load_factor * capacity)

    # if no value for hash code yet, or key matches hash
    if codes[hash_code].nil? || codes[hash_code].key == key
      new_list(new_node, hash_code)
    else
      # list for collision
      add_to_list(new_node, hash_code)
    end
  end

  def new_list(node, code)
    list = LinkedList.new
    list.head = node
    @codes[code] = list
  end

  def add_to_list(node, code)
    list = codes[code]
    tail = list.find_tail
    tail.next = node
  end

  # get method
  def get(key)
    hash_code = hash(key)

    return nil unless @codes[hash_code]

    list = @codes[hash_code]
    list.find_value(key)
  end

  def has?(key)
    hash_code = hash(key)

    return false unless @codes[hash_code]

    list = @codes[hash_code]
    list.includes_value?(key)
  end

  def remove(key)
    hash_code = hash(key)

    return nil unless @codes[hash_code]

    list = @codes[hash_code]
    list.remove_node(key)
  end

  # keep working on this
  def length
    return 0 unless codes

    codes.values.reduce do |total, list|
      total + list.length
    end
  end

  def clear
    codes.each_key do |hash_code|
      delete(hash_code)
    end
  end

  def keys
    codes.values.reduce([]) do |key_array, list|
      current_node = list.head
      while current_node
        key_array.push(current_node.key)
        current_node = current_node.next
      end
    end
  end

  def entries
    codes.values.reduce([]) do |key_array, list|
      current_node = list.head
      while current_node
        key_array.push([current_node.key, current_node.value])
        current_node = current_node.next
      end
    end
  end
end
