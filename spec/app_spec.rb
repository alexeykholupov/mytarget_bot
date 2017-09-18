require 'app'

describe 'App' do
  context 'construction' do
    appname = 'Some App'
    url = 'someurl.com'
    app = App.new(appname, url)

    it 'return correct appname' do
      expect(app.appname).to eq appname
    end
    it 'returns correct url' do
      expect(app.url).to eq url
    end
  end
end
