# frozen_string_literal: true

# node class for linked list
class Node
  attr_accessor :key, :value, :next

  def initialize(key, value)
    @key = key
    @value = value
    @next = nil
  end
end
