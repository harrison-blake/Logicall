# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

account = Account.find_or_create_by!(company_name: "Test Company") do |a|
  a.industry = "Healthcare"
  a.phone_number = "555-123-4567"
  a.email = "contact@testcompany.com"
end

User.find_or_create_by!(email: "owner@test.com") do |u|
  u.name = "Test Owner"
  u.password = "password"
  u.account = account
  u.role = :owner
end
