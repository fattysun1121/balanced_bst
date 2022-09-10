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

  def insert(value)
    node = Node.new value
    unless @array.include?(value)
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

  def pretty_print(node = @root, prefix = '', is_left = true)
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
end

t = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

t.pretty_print
