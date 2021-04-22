# frozen_string_literal: true

class Item
  attr_accessor :title, :subtitle, :arg, :variables

  def initialize(title, subtitle, arg = nil, variables = nil)
    @title = title
    @subtitle = subtitle
    @arg = arg
    @variables = variables
  end

  def to_alfred_item
    alfred_item = {
      title: title,
      subtitle: subtitle
    }

    alfred_item[:arg] = arg unless arg.nil?
    alfred_item[:variables] = variables unless variables.nil?

    alfred_item
  end
end
