# Definition for a binary tree node.
# class TreeNode
#     attr_accessor :val, :left, :right
#     def initialize(val)
#         @val = val
#         @left, @right = nil, nil
#     end
# end

# @param {TreeNode} root
# @param {Integer} k
# @return {Integer}
def kth_smallest(root, k)
    stack = []
    stack.push root
    nextNode = root
    visited = []
    while true do
        left = left_most_node(nextNode, stack, visited)
        k -= 1
        return left.val if(k == 0)
        nextNode = stack.pop
        k -= 1
        return nextNode.val if(k == 0)
        visited.push nextNode
    end
end

def left_most_node (node, stack, visited)
    if(!(node.left.nil?) && !(visited.include? node.left))
        stack.push node
        return left_most_node(node.left, stack, visited)
    end

    if(!(node.right.nil?) && !(visited.include? node.right))
        stack.push node
        return left_most_node(node.right, stack, visited)
    end
    visited.push node
    return node
end



