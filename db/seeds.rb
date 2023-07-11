# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

date_ranges = [
  ["2023-04-15", "2023-04-24"],
  ["2023-05-01", "2023-05-15"],
  ["2023-05-21", "2023-05-30"],
  ["2023-06-06", "2023-06-20"],
  ["2023-07-06", "2023-07-15"],
  ["2023-07-21", "2023-08-04"],
  ["2023-08-11", "2023-08-20"],
]

# Clear existing data to avoid duplicates when seeding
Batch.destroy_all
Package.destroy_all

# Iterate through the date ranges and create Batch records
date_ranges.each do |start_date, end_date|
  Batch.create!(
    start_date: Date.parse(start_date),
    end_date: Date.parse(end_date),
  )
end

# Create Package records
