class GraphNode

  attr_accessor :neighbors, :val

  def initialize val
    @val = val
    @neighbors = Set.new
  end

  def add_neighbor node
    return if node.class != GraphNode
    result = @neighbors.push? node
    !result.nil?
  end
end



def clone (graph_node)

  queue = Queue.new
  queue.push graph_node
  hash_map = {}

  node_clone = GraphNode.new graph_node.val
  hash_map[graph_node] = node_clone

  while !queue.empty? do
    node = queue.pop

    neighbors = node.neighbors

    neighbors.each do |neighbor|
      if hash_map[neighbor].nil?
        neighbor_clone = GraphNode.new neighbor.val
        hash_map[neighbor] = neighbor_clone
        queue.push neighbor
      end

      hash_map[node].neighbors.push? hash_map[neighbor]

    end

end




