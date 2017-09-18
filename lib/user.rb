class User
  attr_reader :login, :password
  def initialize(login, password)
    @login = login
    @password = password
  end
end
