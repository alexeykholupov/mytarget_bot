require 'capybara'
class Bot
attr_reader :session, :environment, :authenticate, :placement_list
DEVELOPMENT = 'https://target-sandbox.my.com'.freeze
PRODUCTION = 'https://target.my.com'.freeze
def initialize(user, app, environment, session)
  @user = user
  @app = app
  @session = session
  @environment = DEVELOPMENT if environment == '2'
  @environment = PRODUCTION if environment == '1'
  @authenticate = false
end
def authenticate_user
  signin_button = "//span[@class= 'js-button ph-button ph-button_profilemenu ph-button_light ph-button_profilemenu_signin']"
  @session.visit @environment
  sleep 10
  @session.find(:xpath, signin_button).click
  @session.fill_in('login', with: @user.login)
  @session.fill_in('password', with: @user.password)
  @session.click_on('Sign in')
  @authenticate = true
end

def create_app
  if @authenticate == true
    create_app_button = "//span[@class= 'main-button__label']"
    next_button = "//div[@class= 'paginator__button paginator__button_right js-control-inc']"
    @session.visit environment + "/create_pad_groups/"
    @session.fill_in('Site/app name', with: @app.appname)
    @session.fill_in('Enter site/app URL', with: @app.url)
    sleep 10
    @session.find(:xpath, create_app_button).click
    sleep 10
    while @session.has_no_selector?('a', :text => @app.appname) do
      @session.find(:xpath, next_button).click  
    end 
    @session.find("a", :text => @app.appname).click
  else
    p 'You are not authenticated'
  end
  @pad_group_id = @session.current_url.gsub(/[^0-9]/, '')
end

def created?
  if @pad_group_id != nil
    return true
  else
    return false
  end
end

def create_placements(n)
  n.times do
    session.visit environment + "/pad_groups/#{@pad_group_id}/create"
    sleep 5
    session.find(:xpath, "//span[@class= 'create-pad-page__save-button js-save-button']").click
    sleep 5
  end
  sleep 20
  @placement_list = session.all(:xpath, "//a[@class= 'pads-list__link js-pads-list-label']").map do |a|
    "name: #{a['text']}, id: #{a['href'].gsub(/[^0-9]/, '')}"
  end
end

def finish_work
puts "Bot finished his work, information about app/placements: "
puts "App name: #{@app.appname} \nApp url: #{@app.url} \nApp id: #{@pad_group_id}"
puts "Placements number: #{@placement_list.count}"
puts "Placements list:\n" 
@placement_list.each { |a| puts a }
end

end
