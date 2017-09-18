
require 'capybara'
require 'headless'
require_relative 'lib/user'
require_relative 'lib/app'
require_relative 'lib/bot'
Capybara.default_max_wait_time = 30
PLACEMENTS_NUMBER = 4
puts "This is bot for ad placement on myTarget service."
confirm = "null"
while confirm.downcase != "yes"
  puts 'Enter valid login:'
  login = gets.chomp
  puts 'Enter valid password:'
  password = gets.chomp
  puts 'Enter valid url for app:'
  url = gets.chomp
  puts 'Is this information correct?'
  puts "login: #{login}" + "\npassword: #{password}" + "\napp url: #{url}" + "\nyes/no?"
  confirm = gets.chomp
end

environment = 0
until environment == "1" || environment == "2"
  puts "Choose environment: " + "\n 1 = Production." + "\n 2 = Test." + "\n1/2?"
  environment = gets.chomp
end
headless = Headless.new
headless.start
session = Capybara::Session.new(:selenium)
session.visit url
appname = session.find(:xpath, "//h1[@itemprop= 'name']").text
app = App.new(appname, url)
user = User.new(login, password)
bot = Bot.new(user, app, environment, session)

bot.authenticate_user
bot.create_app
bot.create_placements(PLACEMENTS_NUMBER)
bot.finish_work
headless.destroy
