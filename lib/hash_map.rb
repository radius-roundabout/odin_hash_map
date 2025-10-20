# frozen_string_literal: true

require_relative 'linked_list'
require_relative 'node'

# hash map class
class HashMap
  attr_accessor :load_factor, :capacity, :codes

  def initialize
    @load_factor = 0.75
    @capacity = 16
    @codes = []
  end

  # hashing methods
  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code % capacity
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
    expand if find_load >= load_factor
    set_node(key, value)
  end

  def print_codes(codes)
    codes.each do |list|
      puts list if list
    end
  end

  def find_load
    return 0 if codes.empty?

    full_buckets = codes.reduce(0) do |total, value|
      total += 1 if value.instance_of?(LinkedList)
      total
    end

    full_buckets.to_f / @capacity
  end

  def set_node(key, value)
    hash_code = hash(key)
    new_node = Node.new(key, value)

    return new_list(new_node, hash_code) if codes[hash_code].nil?

    list = codes[hash_code]
    key_included = list.find_node(key)
    return key_included.value = value if key_included

    add_node(new_node, list)
  end

  def new_list(node, code)
    list = LinkedList.new
    list.head = node
    @codes[code] = list
  end

  def add_node(node, list)
    tail = list.find_tail
    tail.next = node
  end

  # expands number of buckets
  def expand
    @capacity = capacity * 2

    all_entries = entries
    @codes = Array.new(new_cap)

    all_entries.each do |entry|
      set_node(entry[0], entry[1])
    end
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

    codes.reduce(0) do |total, list|
      total + list.length
    end
  end

  def clear
    codes.each do |list|
      delete(list)
    end
  end

  def keys
    codes.reduce([]) do |key_array, list|
      current_node = list.head
      while current_node
        key_array.push(current_node.key)
        current_node = current_node.next
      end
    end
  end

  def entries
    codes.reduce([]) do |key_array, list|
      current_node = list.head
      while current_node
        key_array.push([current_node.key, current_node.value])
        current_node = current_node.next
      end
    end
  end
end
