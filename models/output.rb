# frozen_string_literal: true

class Output
  attr_accessor :items

  def initialize
    @items = []
  end

  def add_item(item)
    items << item
  end

  def print_output(variables = {})
    {
      variables: variables,
      items: items.map(&:to_alfred_item)
    }.to_json
  end

  def print_variables(variables = {})
    {
      variables: variables
    }.to_json
  end
end
