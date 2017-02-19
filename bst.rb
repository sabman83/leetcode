require 'pry-byebug'

class Node
  attr_accessor :val, :left, :right
  def initialize val
    @val = val
    @left = @right = nil
  end
end

#[5,3,6,2,4,nil,7]
def build_tree arr
  root = Node.new arr.shift
  q = Queue.new
  q.push root
  while(!arr.empty?) do
    node = q.pop
    val = arr.shift
    if !val.nil?
      node.left = Node.new val
      q.push node.left
    else
      node.left = nil
    end

    val = arr.shift
    if !val.nil?
      node.right = Node.new val
      q.push node.right
    else
      node.right = nil
    end
  end
  root
end

def print_tree arr
  root = build_tree(arr.clone)
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
      if !node.nil?
        tmp[pos]=  node.val.to_s
        stack.push node.left
        stack.push node.right
      else
        tmp[pos]=  " "
      end

      pos += 2 ** (height - level + 1)
    end
    print tmp.join('  ')
    level += 1
  end
end


def lowest_common_ancestor(root, p, q)
    return root if root.nil?

    arr = []
    queue = Queue.new
    queue.push root
    pIndex = nil
    qIndex = nil
    #do a BFS and add nodes to array till p and q are found
    while !queue.empty? && (pIndex.nil? || qIndex.nil?) do
        node = queue.pop
        arr.push node
        if !node.nil? && node.val == p.val
            pIndex = arr.length-1
        elsif !node.nil? && node.val == q.val
            qIndex = arr.length-1
        end

        queue.push node.nil? ? nil : node.left
        queue.push node.nil? ? nil : node.right
    end

    while (pIndex != qIndex) && (pIndex >= 0) && (qIndex >= 0) do
      if pIndex < qIndex
        qIndex = qIndex%2 == 0 ? (qIndex/2) -1 : qIndex/2
      else
        pIndex = pIndex%2 == 0 ? (pIndex/2) -1 : pIndex/2
      end
    end


    arr[pIndex].val

    binding.pry


end


def get_node_with_value root, val
  queue = Queue.new
  queue.push root
  node = root
  while !queue.empty? do
    node = queue.pop
    return node if node.val == val
    if !node.left.nil?
      return node.left if node.left.val == val
      queue.push node.left
    end
    if !node.right.nil?
      return node.right if node.right.val == val
      queue.push node.right
    end
  end
  nil
end

def lowest_common_ancestor_soln(root, p, q)
    return root if [nil, p, q].index root
    left = lowest_common_ancestor(root.left, p, q)
    right = lowest_common_ancestor(root.right, p, q)
    binding.pry
    left && right ? root : left || right
end

arr = [3,5,1,6,2,0,8,nil,nil,7,4]
#arr = [37,-34,-48,nil,-100,-100,48,nil,nil,nil,nil,-54,nil,-71,-22,nil,nil,nil,8]
root = build_tree(arr)
p = get_node_with_value root,-100
q = get_node_with_value root,-100
lowest_common_ancestor_soln root,q,p


def breadth_first_search_tree root, val

  queue = [root]

  while queue.size >0 do
    node = queue.shift
    next if node.nil?
    return node if node.val == val
    queue.push node.left
    queue.push node.right
  end

  return nil
end


def search_bst root, val
  while !root.nil? do
    return root if root.val == val
    root = val > root.val ? root.right : root.left
  end

  return nil
end

def delete_node(root, key)
  return root if root.nil?

  if(root.val < key)
    root.right = delete_node(root.right, key)
  elsif(root.val > key)
    root.left = delete_node(root.left, key)
  else
    if(root.right.nil?)
      leftTree = root.left
      root.left = nil
      return leftTree
    elsif(root.left.nil?)
      rightTree = root.right
      root.right = nil
      return rightTree
    end

    minVal = find_min(root.right)
    root.val = minVal
    root.right  = delete_node(root.right, minVal)
  end

  return root

end

def find_min(root)
  while(!root.left.nil?) do
    root = root.left
  end
  return root.val
end


arr = [5,3,6,2,4,nil,7]
root = build_tree(arr)
root = delete_node(root, 3)




