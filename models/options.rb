# frozen_string_literal: true

class Options
  def self.available
    [
      Item.new('kks', 'View current time entry', 'kks'),
      Item.new('kkt', 'List time entries', 'kkt')
    ]
  end
end
