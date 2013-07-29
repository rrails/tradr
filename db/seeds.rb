# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all
Stock.destroy_all

u1 = User.create(:email => 'bob@gmail.com', :balance => 100_000, :password => 'a', :password_confirmation => 'a')
u2 = User.create(:email => 'sue@gmail.com', :balance => 115_300, :password => 'a', :password_confirmation => 'a')

s1 = Stock.create(:symbol => 'aapl', :shares => 10, :purchase_price => 10.00)
s2 = Stock.create(:symbol => 'goog', :shares => 25, :purchase_price => 20.00)
s3 = Stock.create(:symbol => 'amzn', :shares => 15, :purchase_price => 30.00)
s4 = Stock.create(:symbol => 'msft', :shares => 75, :purchase_price => 40.00)
s5 = Stock.create(:symbol => 'ge', :shares => 35, :purchase_price => 50.00)

u1.stocks = [s1, s2, s3, s4]
u2.stocks = [s5]