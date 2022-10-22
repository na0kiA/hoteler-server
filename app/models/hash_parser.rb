# frozen_string_literal: true

class HashParser
  attr_accessor :nodes

  def parse(src_hash)
    @key_path = []
    @nodes = []
    recursive_parse(src_hash)
  end

  def recursive_parse(parent)
    case parent
    when Array
      parent.each_with_index do |index, key|
        add_node(key, index)
      end
    when Hash
      parent.each do |key, val|
        add_node(key, val)
      end
    end
    @key_path.pop
  end

  def add_node(key, val)
    @key_path << key
    node = {
      key:,
      val:,
      key_path: @key_path.clone
    }
    @nodes << node
    recursive_parse(val)
  end
end
