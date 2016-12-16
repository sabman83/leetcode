require 'pry-byebug'
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
  while queue.size != 0 && arr.size != 0 do
    node = queue.shift
    node.left = TreeNode.new(arr.shift)
    node.right = TreeNode.new(arr.shift)
    queue.push(node.left) if arr.size > 0
    queue.push(node.right) if arr.size > 0
  end
  root
end

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


def invert_tree_sol root
  binding.pry
  return nil if (root == nil)
  right = invert_tree_sol(root.right)
  left = invert_tree_sol(root.left)
  root.left = right
  root.right = left
  root
end


sample_root = generateTree([4,2,7,1,3,6,9])


def _leftmost_univisted_node (visited, stack)
  begin
    node = stack.last
    if (node.nil? || (node.left.nil? && node.right.nil?))
      stack.pop
      return node
    end
    if !node.left.nil? && !visited.include?(node.left)
      stack.push(node.left)
      return _leftmost_univisted_node(visited, stack)
    end
    if !node.right.nil? && !visited.include?(node.right)
      stack.push(node.right)
      return _leftmost_univisted_node(visited, stack)
    end
    stack.pop
    return node
  rescue => e
    binding.pry
  end
end

def _rightmost_univisted_node (visited, stack)
  begin
    node = stack.last
    if (node.nil? || (node.left.nil? && node.right.nil?))
      stack.pop
      return node
    end
    if !node.right.nil? && !visited.include?(node.right)
      stack.push(node.right)
      return _rightmost_univisted_node(visited, stack)
    end
    if !node.left.nil? && !visited.include?(node.left)
      stack.push(node.left)
      return _rightmost_univisted_node(visited, stack)
    end
    stack.pop
    return node
  rescue => e
    binding.pry
  end
end

def swap(node1, node2)
    return if node1.nil? || node2.nil?
    node1 = TreeNode.new(nil) if node1.nil?
    node2 = TreeNode.new(nil) if node2.nil?
    val = node1.val
    node1.val = node2.val
    node2.val = val
end

def invert_tree (root)
  return root if root.nil? || root.val.nil?
  visited = [root]
  rstack = []
  rstack.push(root)
  lstack = []
  lstack.push(root)
  begin
    while !lstack.empty? && !rstack.empty? do
      lnode = _leftmost_univisted_node(visited,lstack)
      visited.push(lnode)
      rnode = _rightmost_univisted_node(visited,rstack)
      visited.push(rnode)
      puts "swapping ", lnode.val, rnode.val
      swap(lnode,rnode)
    end
  rescue => e
    binding.pry
  end
  #get leftmost unvisited node,

  #get rightmost unvisited node,
  #swap
  binding.pry
  root
end

puts invert_tree_sol(sample_root)


# [A]
  #|
  #|
 #[B]<-
  #|   |
  #|   |
 #[C]  |
  #|   |
  #|   |
 #[D]--
  #|
  #|
 #[E]

 #[A`]
  #|
  #|
 #[B`]<-
  #|    |
  #|    |
 #[C`]  |
  #|    |
  #|    |
 #[D`]--
  #|
  #|
 #[E`]


class NodeWithJump
	attr_accessor :val, :next, :jump

  def initialize val
  	@val = val
    @next, @jump = nil, nil
  end

  def equals(n)
  	self.val == n.val
  end

end


def deep_copy (n)
	n_copy = NodeWithJump.new(n.value)
	created = {n.value => n_copy}
  while(n != nil)
    n_copy.next = copy_node(n.next, created)
    n_copy.jump = copy_node(n.jump, created)
    n = n.next
    n_copy = n_copy.next
  end

end

def copy_node(n, created)
  if(created[n.value].nil?)
    created[n.value] = NodeWithJump.new(n.value)
  end
  created[n.value]
end










