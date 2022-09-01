#require 'rails_helper'

RSpec.describe 'PurchasesController', type: :request do
  
    
  user_attrs = FactoryBot.create(:user, password: 'secret')
  token = JsonWebToken.encode({ user_id: user_attrs.id })
  headers = { 'Authorization' => "Bearer #{token}" } 
  let (:headers) {{ 'Authorization' => "Bearer #{token}" } }

  FactoryBot.create_list(:category, 30)  if Product.count < 100

  let(:first_category) { Category.order(:name).first.name }

  describe 'GET top sellings' do
    before do        
      get '/purchases/top_sellings', headers: headers
    end

    it 'top sellings rank' do
      expect(json_body).to be_a_kind_of(Array)
      expect(json_body[0]["category_name"]).to eq(first_category)
    end
  end

  describe 'GET purchases' do
    context 'purchases paginate' do
      before do        
        get '/purchases', headers: headers, params: {page: 1, per_page: 10}
      end

      it 'get first page of purchases' do
        expect(json_body['data'].size).to eq(10)
        expect(json_body['paginate']['current_page']).to eq(1)
      end
    end

    context 'purchases filters' do
      # Review: Queda demostrado tu conocimiento en rspec.
      #         Tip: mejor si se hubiése testeado todas las combinaciones de parámetro con metraprograming quizás.

      it 'filter by date' do
        params  = {page: 1, per_page: 10, start_date: Time.zone.now - 1.hour, end_date: Time.zone.now}
        get '/purchases', headers: headers, params: params 
        expect(json_body['data'][0]['created_at']).to be < Time.zone.now
      end

      it 'filter by color' do
        params  = {page: 1, per_page: 10, color: 'blue'}
        get '/purchases', headers: headers, params: params 
        expect(json_body['data'][0]['product']['extra']['color']).to include('blue')
      end

      it 'filter by material' do
        params  = {page: 1, per_page: 10, material: 'Bronze'}
        get '/purchases', headers: headers, params: params 
        expect(json_body['data'][0]['product']['extra']['material']).to eq('Bronze')
      end

      it 'filter by units' do
        params  = {page: 1, per_page: 10, units: 3}
        get '/purchases', headers: headers, params: params 
        expect(json_body['data'][0]['units']).to be >= 3
      end

      it 'filter by amount' do
        params  = {page: 1, per_page: 10, amount: 2}
        get '/purchases', headers: headers, params: params 
        expect(json_body['data'][0]['amount']).to be >= 2
      end

      it 'filter by buyer name' do
        params  = {page: 1, per_page: 10, buyer: 'Al'}
        get '/purchases', headers: headers, params: params 
        expect(json_body['data'][0]['buyer_name']).to include('Al')
      end
      
    end

  end

end
