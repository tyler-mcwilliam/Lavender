# namespace :group do
#   desc "Storing current group portfolio value for all groups (async)"
#   task :update_all => :environment do
#     positions = Position.all
#     puts "Enqueuing update of #{positions.size} groups..."
#     positions.each do |position|
#       UpdatePerformanceJob.update_position(position.id)
#     end
#     puts "Done"
#     groups = Group.all
#     puts "Enqueuing update of #{groups.size} groups..."
#     groups.each do |group|
#       UpdatePerformanceJob.update_group(group.id)
#     end
#     puts "Done"
#     users = User.all
#     puts "Enqueuing update of #{users.size} groups..."
#     users.each do |user|
#       UpdatePerformanceJob.update_user(user.id)
#     end
#     puts "Done"
#     # rake task will return when all jobs are _enqueued_ (not done).
#   end
# end
