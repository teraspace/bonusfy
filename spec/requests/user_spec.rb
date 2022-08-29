RSpec.describe UsersController, type: :request do
  describe 'POST /create' do

    context 'when valid' do
      let (:user_attrs) { FactoryBot.attributes_for(:user) }
      before do        
        post users_url, params: { user: user_attrs }
      end
      
      it 'should be json response' do
        expect(response.content_type).to include 'application/json'
      end

      it 'should be user' do
        expect(json_body['user']['id']).to be_a_kind_of(Integer)
        expect(json_body['user']['name']).to include user_attrs[:name]
        expect(json_body['user']['email']).to include user_attrs[:email]
      end

    end
    
    context 'when params is empty' do
      before do        
        post users_url
      end

      it 'should be json response with specific invalid parameters' do
        expect(response.content_type).to include 'application/json'
        expect(json_body['error']).to include 'param is missing'
      end

    end
  end

  describe 'POST /login' do
    
    context 'with valid credentials' do
      it 'should be json response' do
        user_attrs = FactoryBot.create(:user, password: 'secret')
        post '/login', params: { email: user_attrs[:email], password: 'secret' }
        expect(response.content_type).to include 'application/json'        
        expect(json_body['name']).to include user_attrs[:name]
        expect(json_body['token'].length).to be > 50
        expect(json_body['expiration'].to_datetime).to be_a_kind_of(DateTime)
      end
    end

    context 'with valid credentials' do
      it 'should be json response' do
        user_attrs = FactoryBot.create(:user, password: 'secret')
        post '/login', params: { email: user_attrs[:email], password: '1111' }
        expect(response.content_type).to include 'application/json'        
        expect(json_body['error']).to include 'Invalid email or password'
      end
    end
  end

  describe 'GET /auto_login' do
    context 'with valid credentials' do           
      user_attrs = FactoryBot.create(:user, password: 'secret')
      token = JsonWebToken.encode({ user_id: user_attrs.id })
      headers = { 'Authorization' => "Bearer #{token}" } 
      let (:headers) {{ 'Authorization' => "Bearer #{token}" } }

      it 'should be json response' do
        post '/auto_login', headers: headers
        expect(response.content_type).to include 'application/json'        
        expect(json_body["name"]).to include user_attrs[:name]
      end

    end
  end

end
