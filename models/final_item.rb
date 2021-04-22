# frozen_string_literal: true

require_relative 'item'

class FinalItem < Item
  attr_accessor :title, :subtitle, :arg, :variables

  def initialize(title, subtitle, arg = nil, variables = {})
    super

    # @arg = 'done'
    variables[:step] = 'final'
    variables[:notification_title] ||= 'Oops notification title was not set 😢'
  end

  def to_alfred_item
    {
      title: title,
      subtitle: subtitle,
      arg: arg,
      variables: variables
    }
  end
end
