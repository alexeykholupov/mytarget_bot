require 'user'

describe 'User' do
  context 'construction' do
    login = 'login'
    password = 'password'
    user = User.new(login, password)

    it 'returns correct login' do
      expect(user.login).to eq login
    end
    it 'returns correct password' do
      expect(user.password).to eq password
    end
  end
end
