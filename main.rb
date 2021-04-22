# frozen_string_literal: true

require 'awesome_print'

require_relative 'models/config'
require_relative 'models/final_item'
require_relative 'models/item'
require_relative 'models/output'
require_relative 'models/options'
require_relative 'models/rest_client'

config = Config.new
rest_client = AppRestClient.new
output = Output.new



# step = ENV['step']
# print '' and exit if step == 'final'

if ARGV.count.zero? || ARGV.first.empty?
  print Output.print_output(
    [
      Options.available
    ].flatten
  )
  exit 0
end

variables = JSON.parse(ENV['variables']) unless ENV['variables'].nil?
option = ENV['option']
timesheet = {
  id: ENV['timesheet_id'],
  description: ENV['timesheet_description']
}
action = ENV['action']

if ARGV[0] == 'final'
  if option == 'kkt' || option == 'kks'
    variables[:timesheet_id] = ARGV[1]
    variables[:option] = option
    print timesheet[:description]
  else
    print ARGV[1]
  end
  ARGV.shift
  exit
end

case ARGV[0]
when 'kks'
  if !action.nil?
    rest_client.patch("timesheets/#{timesheet[:id]}/stop")
  elsif timesheet[:id] && timesheet[:id] != '0'
    output.add_item(
      FinalItem.new(
        'Stop',
        'Stop the current time entry',
        'kks',
        {
          timesheet_id: timesheet[:id],
          timesheet_description: timesheet[:description],
          action: 'stop',
          notification_title: "Stopped #{timesheet[:description]}"
        }
      )
    )
  else
    current_task = rest_client.get('timesheets/active')
    if current_task.empty?
      output.add_item(FinalItem.new('No time entry currenty running', ''))
    else
      current_task = current_task.first
      output.add_item(Item.new(current_task['description'], "#{current_task['activity']['project']['name']} - #{current_task['activity']['name']}", 'kks', { timesheet_id: current_task['id'], timesheet_description: current_task['description'] }))
    end
  end
when 'kkt'

  case action
  when 'restart'
    rest_client.patch("timesheets/#{timesheet[:id]}/restart")
  else
    
  end
  
  if timesheet[:id] && timesheet[:id] != '0'
    output.add_item(
      FinalItem.new(
        'Restart',
        'Restart the time entry',
        'kkt',
        {
          timesheet_id: timesheet[:id],
          timesheet_description: timesheet[:description],
          action: 'restart',
          notification_title: "Restarted #{timesheet[:description]}"
        }
      )
    )
  else
    tasks = rest_client.get('timesheets/recent')
  
    tasks.each do |task|
      output.add_item(Item.new(task['description'], "#{task['project']['name']} - #{task['activity']['name']}", 'kkt', { timesheet_id: task['id'], timesheet_description: task['description'] }))
    end
  end
when 'kko'
  case action
  when 'set_api_url'
    rest_client.patch("timesheets/#{timesheet[:id]}/restart")
  else
    
  end

  output.add_item(Item.new(config.api_url, 'Go to your Kimai profile page to get one', 'kko', { action: 'set_api_url' }))
  output.add_item(Item.new('❌ Set API token', 'Go to your Kimai profile page to get one', 'kko', { action: 'set_token' }))
else
  activities = rest_client.get('activities')

  activities.each do |a|
    output.add_item(Item.new(a['name'], a['project']))
  end
end

print output.print_output(variables)
