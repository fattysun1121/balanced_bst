# frozen_string_literal: true

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    data <=> other.data
  end

end

class Tree
  def initialize(array)
    @root = build_tree(array)
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

  def insert(value)
    node = Node.new value
    if find(value).nil?
      current_node = @root
      while current_node.left != node && current_node.right != node
        if node > current_node
          if current_node.right.nil?
            current_node.right = node
          else
            current_node = current_node.right
          end
        elsif current_node.left.nil?
          current_node.left = node
        else
          current_node = current_node.left
        end
      end
    end
  end

  def delete(val)
    @root = delete_rec(@root, val)
  end

  def find(val)
    find_rec(@root, val)
  end

  def level_order(queue=[@root], result=[], &block)
    unless queue.empty?
      data_node = queue.shift
      queue << data_node.left unless data_node.left.nil?
      queue << data_node.right unless data_node.right.nil?
      if block_given?
        yield(data_node.data)
        level_order(queue, &block)
      else
        result << data_node.data
        level_order(queue, result)
      end
    end
    unless block_given?
      result
    end
  end

  def inorder(node=@root, result=[], &block)
    # left data right
    if block_given?
      inorder(node.left, &block) unless node.left.nil?
      yield(node.data)
      inorder(node.right, &block) unless node.right.nil?
    else
      inorder(node.left, result) unless node.left.nil?
      result << node.data
      inorder(node.right, result) unless node.right.nil?
      result
    end
  end

  def preorder(node=@root, result=[], &block)
    # data left right 
    if block_given?
      yield(node.data)
      preorder(node.left, &block) unless node.left.nil?
      preorder(node.right, &block) unless node.right.nil?
    else
      result << node.data
      preorder(node.left, result) unless node.left.nil?
      preorder(node.right, result) unless node.right.nil?
      result
    end
  end

  def postorder(node=@root, result=[], &block)
    # left right data
    if block_given?
      postorder(node.left, &block) unless node.left.nil?
      postorder(node.right, &block) unless node.right.nil?
      yield(node.data)
    else
      postorder(node.left, result) unless node.left.nil?     
      postorder(node.right, result) unless node.right.nil?
      result << node.data
      result
    end
  end

  def height(node)
    if node.left && node.right
      1 + [height(node.left), height(node.right)].max
    elsif node.left.nil? && node.right.nil?
      0
    elsif node.left.nil?
      1 + height(node.right)
    else
      1 + height(node.left)
    end
  end

  def depth(root=@root, node)
    if node < root
      1 + depth(root.left, node)
    elsif node > root
      1 + depth(root.right, node)
    else
      0
    end
  end

  def balanced?(root=@root)
    if root.nil?
      0
    else
      lh = balanced?(root.left)
      return -1 if lh == -1
      rh = balanced?(root.right)
      return -1 if rh == -1
      return -1 if (lh - rh).abs > 1
      [lh, rh].max + 1
    end
  end

  def rebalance
    @root = build_tree(level_order)
  end
  def pretty_print(node=@root, prefix='', is_left=true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def delete_rec(root, val)
    if root.nil?
      return root
    end

    if val < root.data
      root.left = delete_rec(root.left, val)
    elsif val > root.data
      root.right = delete_rec(root.right, val)
    elsif root.left.nil?
      return root.right
    elsif root.right.nil?
      return root.left
    else
      root.data = min_value(root.right)
      root.right = delete_rec(root.right, root.data)
    end
    root
  end

  def min_value(root)
    minv = root.data
    until root.left.nil?
      minv = root.left.data
      root = root.left
    end
    minv
  end

  def find_rec(root, val)
    if root.nil?
      return root
    end
    if val < root.data
      find_rec(root.left, val)
    elsif val > root.data
      find_rec(root.right, val)
    else
      root
    end
  end
end

t = Tree.new(Array.new(15) { rand(1..100) })
puts t.balanced? > -1
p t.level_order, t.preorder, t.postorder, t.inorder
5.times do |i|
  t.insert(i + 100)
end
puts t.balanced? > -1
t.rebalance
puts t.balanced? > -1
p t.level_order, t.preorder, t.postorder, t.inorder

