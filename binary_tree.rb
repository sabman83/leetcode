require 'pry'
# Definition for a binary tree node.
class TreeNode
   attr_accessor :val, :left, :right
   def initialize(val)
       @val = val
       @left, @right = nil, nil
   end
end

def generateTree(arr)
  val = arr.slice!(0)
  node  = TreeNode.new(val)
  root = node
  queue = [node]
  while queue.size != 0 do
    node = queue.shift
    node.left = TreeNode.new(arr.shift)
    node.right = TreeNode.new(arr.shift)
    queue.push(node.left) if arr.size > 0
    queue.push(node.right) if arr.size > 0
  end
  root
end

#def print_tree(arr)
  #root = generateTree(arr.clone)
  #height = Math.log2(arr.size).ceil
  #maxLeaves = 2 ** (height - 1)
  #maxWidth = 3 * maxLeaves - 2 # maximum width the tree can have including spaces
  #level = 1
  #parentStack = [root]
  #levelStack = [root]
  #binding.pry
  #while parentStack.size != 0 do
    #printArr = Array.new(maxWidth)
    #while levelStack.size !=0 do
      #node = levelStack.shift
      #printArr[maxWidth/(2*level)] = node.val
    #print printArr.join(' ')
    #parentStack.push(node.left) if node.left
    #parentStack.push(node.right) if node.right
  #end
#end

def alt_print_tree arr
  root = generateTree(arr.clone)
  height = Math.log2(arr.size).ceil
  maxLeaves = 2 ** (height - 1)
  maxWidth = 2 * maxLeaves# maximum width of tree
  stack = [root]
  level = 1
  while level <= height
    puts
    puts
    tmp = Array.new(maxWidth)
    pos = (maxWidth.to_f / (2 * level)).floor
    (1..(2 ** (level-1))).each do |i|
      node = stack.shift
      tmp[pos]=  node.val.to_s
      stack.push node.left
      stack.push node.right
      pos += 2 ** (height - level + 1)
    end
    print tmp.join('  ')
    level += 1
  end
end

alt_print_tree([4,2,7,1,3,6,9])
