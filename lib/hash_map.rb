# frozen_string_literal: true

require_relative 'linked_list'
require_relative 'node'

# hash map class
class HashMap
  attr_accessor :load_factor, :capacity, :codes, :load

  def initialize
    @load_factor = 0.75
    @capacity = 16
    @codes = []
    @load = 0
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
    hash_code = hash(key)
    list = codes[hash_code]

    if list
      existing_key = check_for_key(list, key, value)
      return if existing_key
    end

    expand if (load.to_f / capacity) >= load_factor
    new_node = Node.new(key, value)

    return create_new_list(hash_code, new_node) unless list

    add_to_list(list, new_node)
  end

  def check_for_key(list, key, value)
    key_included = list.find_node(key)
    return nil unless key_included

    key_included.value = value

    print_codes
    puts load

    key_included
  end

  def create_new_list(code, node)
    list = LinkedList.new
    list.head = node
    @codes[code] = list
    @load += 1

    print_codes
    puts load
  end

  def add_to_list(list, node)
    tail = list.find_tail
    tail.next = node
    @load += 1

    print_codes
    puts load
  end

  # print hash map entries as arrays or linked lists of arrays
  def print_codes
    codes.each do |list|
      print list || '[nil, nil] '
    end
    puts
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
      if list
        length = list.length
        total += length
      end
      total
    end
  end

  def clear
    codes.each_index do |index|
      @codes[index] = nil
    end
  end

  def keys
    codes.each_with_object([]) do |list, key_array|
      next unless list

      current_node = list.head
      while current_node
        key_array << current_node.key
        current_node = current_node.next
      end
    end
  end

  def entries
    codes.each_with_object([]) do |list, key_array|
      next unless list

      current_node = list.head
      while current_node
        key_array << [current_node.key, current_node.value]
        current_node = current_node.next
      end
    end
  end
end
