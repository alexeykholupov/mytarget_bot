class App
attr_reader :appname, :url
  def initialize(appname, url)
    @appname = appname
    @url = url
  end
end