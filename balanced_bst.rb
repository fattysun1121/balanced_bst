class Node
include Comparable
attr :data

  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other_node)
    data <=> other_node.data
  end
    
end

