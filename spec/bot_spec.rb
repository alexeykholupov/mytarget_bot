require 'bot'
require 'app'
require 'user'
require 'headless'
describe 'Bot' do
  Capybara.default_max_wait_time = 30
  puts 'Enter test data:' + "\nLogin: "
  login = gets.chomp
  puts 'Password: '
  password = gets.chomp
  user = User.new(login, password)
  puts 'App url: '
  url = gets.chomp
  headless = Headless.new(destroy_on_exit: false)
  headless.start
  session = Capybara::Session.new(:selenium)
  session.visit url
  appname = session.find(:xpath, "//h1[@itemprop= 'name']").text
  app = App.new(appname, url)
  environment = '2'
  bot = Bot.new(user, app, environment, session)
  context 'authentication' do
    bot.authenticate_user
    it 'authenticate user' do
      expect(bot.authenticate).to eq true
    end
  end
  context 'App creation' do
    bot.create_app
    it 'Creates app' do
      expect(bot.created?).to eq true
    end
  end
  context 'Placement creation' do
    bot.create_placements(1)
    it 'Creates 1 additional placement' do
      expect(bot.placement_list.count).to eq 2
    end
  end
  headless.destroy
end
