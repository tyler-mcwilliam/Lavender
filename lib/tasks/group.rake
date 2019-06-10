namespace :group do
  desc "Storing current group portfolio value for all groups (async)"
  task :update_all => :environment do
    groups = Group.all
    puts "Enqueuing update of #{groups.size} groups..."
    groups.each do |group|
      UpdatePerformanceJob.perform_later(group.id)
    end
    # rake task will return when all jobs are _enqueued_ (not done).
  end
end
