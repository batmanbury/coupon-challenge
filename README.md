Coupon Challenge
================

This application requires:

- Ruby 2.5.0
- Rails 5.1.4

Getting Started
---------------

You can see the demo immediately at https://coupon-challenge.herokuapp.com/

Or set up the project locally:

- After cloning the repository and setting up your Ruby environment, run:
  - `bundle install`
  - `rails db:create db:migrate && rails db:seed`
  - `rails s`
  - (You will also need a pair of secret/publishable Stripe test keys. Ask for those if you're unable to come up with some.)

Navigating the Site
-------------------

- Click "Register" to register a new user, or with the database seeded you can login as any user with the following credentials:
  - email: `user_1@example.com`
  - password: `password`
  - (You can replace the "1" in `user_1` with any integer up to 999 to login as any user).
- Click "Account" in the navbar then:
  - Click "Make a $20 Deposit"
  - Enter `4242 4242 4242 4242` in the credit card field
  - Enter a future MM/YY, and any 3-digit CVC
  - You can now get coupons from the Marketplace within your balance.
- Post a Coupon:
  - From the Account page, click "Post a Coupon"
  - Enter a brand name by selecting from the autocomplete, or entering a new name
  - Enter a coupon value and submit
  - You will see the coupon in your Posted Coupons, as well as the Marketplace.
- Export Data
  - Each data-table view (Marketplace, Transactions, Users) has an "Export" button.
  - Click the Export button for a download prompt.
  - Download the full data-table, or a search-filtered list, in excel format.

Other Highlights
-----------------
- Implements a page-specific assets architecture.
- DataTables views are customized for server-side pagination,
- `CouponTransferService` handles validations and balance adjustments for coupon transfers.
  - RSpec tests present for this part of the code.
- Autocompleted Brand field during Coupon creation.
  - (When you post a new coupon, select an existing Brand through the autocomplete, or type a new Brand to create one.)


Tests
-----
Run RSpec tests with `rspec spec/services`


*************************
*This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).*
