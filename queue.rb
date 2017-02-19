require './stack.rb'
require 'pry-byebug'

class Queue
  def initialize
    @top_stack = Stack.new
    @rest_stack = Stack.new
  end

  def enqueue data
    @top_stack.add data
  end

  def dequeue
    clean_up
    @rest_stack.remove
  end

  def top
    clean_up
    @rest_stack.top
  end

  private
  def clean_up
    while(@top_stack.size > 0) do
      @rest_stack.add @top_stack.remove
    end
  end
end

