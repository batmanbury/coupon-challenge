require 'activerecord-import'
require 'faker'

# Create Users
users = []
1000.times do |n|
  x_days_ago = Time.zone.now - rand(31..60).days
  users.push User.new(
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: "user_#{n}@example.com",
    balance: 20.0,
    created_at: x_days_ago,
    updated_at: x_days_ago
  )
end
puts "Importing #{users.count} seed users (with $20.00 balances)"
User.import users, validate: false
# Set all user passwords to "password"
User.update_all(encrypted_password: "$2a$11$jXrN0v77OzeGWrvhqZ8yKOTOWOPZC4GketCZMLJTGB9AJRnD3n1dK")

# Create Brands
brand_names = Set.new
loop do
  name = "#{Faker::App.name} #{Faker::Job.field}"
  brand_names.add name
  break if brand_names.count >= 200
end

brands = []
brand_names.each do |brand_name|
  brand = Brand.new(name: brand_name)
  brands.push brand
end
puts "Importing #{brands.count} seed brands"
Brand.import brands

# Create Coupons
# We want to see how the system does with a lot of coupons (~10_000),
# so each user will post between 5 and 15 randomly.
coupons = []
brand_ids = Brand.pluck(:id)
User.pluck(:id).each do |user_id|
  n = rand(5..15)
  n.times do
    x_days_ago = Time.zone.now - rand(30).days
    coupons.push Coupon.new(
      poster_id: user_id,
      brand_id: brand_ids.sample,
      value: rand(1..40) / 2.0, # 0.50 to 20.00 in 50 cent increments
      created_at: x_days_ago,
      updated_at: x_days_ago
    )
  end
end
puts "Importing #{coupons.count} coupons (please wait)"
Coupon.import coupons

# Create Transfers
# We'll attempt to transfer all coupons, but many will be unsuccessful as balances drop.
puts 'Transferring roughly half of all coupons and adjusting balances (please wait longer)'

user_ids = User.pluck(:id)
successful_requests = 0
unsuccessful_requests = 0
Coupon.find_each do |coupon|
  candidates = user_ids - [coupon.poster_id]
  requester = User.find(candidates.sample)
  cts = CouponTransferService.new(coupon, requester)
  successful = cts.transfer!
  successful ? successful_requests += 1 : unsuccessful_requests += 1
  print '-' if successful_requests % 100 == 0 && successful
  # print 'x' if unsuccessful_requests % 100 == 0 && !successful
end

puts "\nDone!"
puts "\n-------- Summary --------"
puts "Total Users ....... #{User.count}"
puts "Total Brands ...... #{Brand.count}"
puts "Total Coupons ..... #{Coupon.count}"
puts "Total Transfers ... #{Transfer.count}"
puts "-------------------------"

total_revenue = Transfer.sum(:commission_amount)
formatted_total = format("$%.2f", total_revenue)

puts "\nCurrent Marketplace Revenue: #{formatted_total}\n\n"
