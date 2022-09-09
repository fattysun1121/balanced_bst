class Node
include Comparable
attr_accessor :data, :left, :right

  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other_node)
    data <=> other_node.data
    
  end
end


class Tree
  def initialize(array)
    @root = build_tree(array)
    @array = array
  end

  def build_tree(array)
    unless array.empty?
      array = array.sort
      array.uniq!
      mid = (0 + array.length - 1) / 2
      root = Node.new(array[mid])
      root.left = build_tree(array.slice(0, mid))
      root.right = build_tree(array.slice(mid + 1, array.length))
      root
    end
  end

  def insert(node)
    unless @array.include?(node.data)
      current_node = @root
      while current_node.left != node && current_node.right != node
        if node > current_node
          unless current_node.right.nil?
            current_node = current_node.right
          else
            current_node.right = node
          end
        else
          unless current_node.left.nil?
            current_node = current_node.left
          else
            current_node.left = node
          end
        end
      end  
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

t = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
t.pretty_print



