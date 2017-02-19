#Implement Double Linked List
#
#
require 'pry-byebug'

class Node

  attr_accessor :prev, :next, :val

  def initialize val
    @val = val
    @prev = nil
    @next = nil
  end

end

class DLinkedList
  attr_accessor :head, :tail
  def initialize capacity
    @head = nil
    @tail = nil
    @capacity = capacity
    @size = 0
  end

  #always add node to head for LRU
  def add val
    node = Node.new val
    if @size == 0
      @head = node
      @tail = node
    else
      node.next = @head
      @head.prev = node
      @head = node
    end

    @size += 1
    @tail = node if @size == 1
    @tail.prev = node if @size == 2
    remove_tail if @size > @capacity
    node
  end

  def remove_tail
    remove @tail.val
  end

  def remove val
    node = get_node_with_value val
    return if node.nil?
    nextNode = node.next
    prevNode = node.prev
    prevNode.next = nextNode if !prevNode.nil?
    nextNode.prev = prevNode if !nextNode.nil?

    if node == @head
      @head = nextNode
    elsif node == @tail
      @tail = prevNode
      @tail.next = nil
    end

    node.prev = nil
    node.next = nil

    @size -= 1
    node
  end

  def move_to_head val
    remove val
    add val
  end

  def get_node_with_value val
    root = @head
    while !root.nil? do
      return root if root.val == val
      root = root.next
    end
    nil
  end

  def print_list
    puts ""
    root = @head
    while !root.nil?
      print " --> " + root.val.to_s
      root = root.next
    end
  end

end

class LRUCache

  attr_reader :capacity, :dlink


=begin
    :type capacity: Integer
=end
    def initialize(capacity)
       @capacity = capacity
       @hash = {}
       @dlink = DLinkedList.new capacity
    end


=begin
    :type key: Integer
    :rtype: Integer
=end
    def get(key)
      return -1 if !(@hash.has_key?(key))

      @dlink.move_to_head key
      @hash[key]
    end


=begin
    :type key: Integer
    :type value: Integer
    :rtype: Void
=end
    def put(key, value)
      if @hash.has_key? key
        @dlink.move_to_head key
        @hash[key] = value
        return @hash
      end
      if @hash.keys.size >= @capacity
        node = @dlink.remove_tail
        @hash.delete node.val
      end
      @hash[key] = value
      @dlink.add key
      @hash
    end

end

