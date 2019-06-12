desc "Storing current group portfolio value for all groups (async). This task is called by the Heroku scheduler add-on"
task update_all: :environment do
  puts "Updating data..."
  #  Data update

  UpdatePerformanceJob.perform_now

  puts "Finished Data Update. Goodbye!"

  # positions = Position.all
  # puts "Enqueuing update of #{positions.size} positions..."
  # positions.each do |position|
  #   UpdatePerformanceJob.update_position(position.id)
  # end
  # puts "Done"
  # groups = Group.all
  # puts "Enqueuing update of #{groups.size} groups..."
  # groups.each do |group|
  #   UpdatePerformanceJob.update_group(group.id)
  # end
  # puts "Done"
  # users = User.all
  # puts "Enqueuing update of #{users.size} users..."
  # users.each do |user|
  #   UpdatePerformanceJob.update_user(user.id)
  # end
  # puts "Done"
  # rake task will return when all jobs are _enqueued_ (not done).
end
