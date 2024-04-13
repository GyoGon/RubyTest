namespace :db do
    desc "Clear all data from the sismologia database"
    task clear_sismologia_data: :environment do
        Feature.destroy_all
        puts "All data from the sismologia database has been cleared"
    end
    end