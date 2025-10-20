# frozen_string_literal: true

require_relative 'node'

# linked list class
class LinkedList
  attr_accessor :head, :next_node

  @head = nil

  def find_tail
    return head unless head.next

    current_node = head.next

    current_node = current_node.next while current_node.next

    current_node
  end

  def find_node(key)
    return head if head.key == key
    return nil unless head.next

    current_node = head

    current_node = current_node.next until current_node.key == key || !current_node.next

    return current_node if current_node.key == key

    nil
  end

  def find_value(key)
    return value if head.key == key

    current_node = find_node(key)

    return value if current_node.value == value

    nil
  end

  def includes_value?(key)
    return true if head.key == key

    current_node = find_node(key)

    return true if current_node.value == value

    false
  end

  def remove_at(key)
    return remove_head(key) if head.key == key

    current_node = head
    prev_node = nil

    while current_node.key != key || current_node.next
      prev_node = current_node
      current_node = current_node.next
    end

    return nil unless current_node.key == key

    prev_node.next = current_node.next
    current_node.value
  end

  def remove_head
    value = head.value
    @head = head.next
    value
  end

  def length
    return 1 unless head.next

    next_node = head.next
    i = 2

    while next_node.next
      next_node = next_node.next
      i += 1
    end
    i
  end

  def to_s
    print "( #{head.value} )"

    current_node = head.next

    while current_node
      print " -> ( #{current_node.value} )"
      current_node = current_node.next
    end

    print ' -> nil '
  end
end
