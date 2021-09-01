require 'rails_helper'

RSpec.describe 'Executors Requests' do
  describe 'create' do
    it 'creates an executor' do
      user_id = create(:user).id
      executor_details = {
        email: 'ex@ample.com',
        name: 'Younger Bobby',
        phone: '555-867-5309'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/executors", headers: headers, params: JSON.generate(executor_details)
      exec = Executor.last

      expect(exec).is_a? Executor
      expect(exec.email).to eq 'ex@ample.com'
      expect(exec.name).to eq 'Younger Bobby'
      expect(exec.phone).to eq '555-867-5309'
      expect(exec.user_id).to eq user_id
    end

    it 'returns serialized executor details' do
      user_id = create(:user).id
      executor_details = {
        email: 'ex@ample.com',
        name: 'Younger Bobby',
        phone: '555-867-5309'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/executors", headers: headers, params: JSON.generate(executor_details)
      expect(response.status).to eq 201
      exec = JSON.parse(response.body, symbolize_names: true)

      expect(exec).is_a? Hash
      expect(exec).to have_key(:data)
      expect(exec[:data]).to have_key(:id)
      expect(exec[:data][:id]).is_a? String
      expect(exec[:data]).to have_key(:type)
      expect(exec[:data][:type]).to eq 'executor'
      expect(exec[:data]).to have_key(:attributes)
      expect(exec[:data][:attributes]).is_a? Hash
      expect(exec[:data][:attributes]).to have_key(:email)
      expect(exec[:data][:attributes][:email]).to eq 'ex@ample.com'
      expect(exec[:data][:attributes]).to have_key(:name)
      expect(exec[:data][:attributes][:name]).to eq 'Younger Bobby'
      expect(exec[:data][:attributes]).to have_key(:phone)
      expect(exec[:data][:attributes][:phone]).to eq '555-867-5309'
    end

    it 'does not create without email' do
      user_id = create(:user).id
      executor_details = {
        name: 'Younger Bobby',
        phone: '555-867-5309'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/executors", headers: headers, params: JSON.generate(executor_details)
      expect(response.status).to eq 400
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message[:error]).to eq 'Missing or Incorrect Executor Params'
    end

    it 'does not create without name' do
      user_id = create(:user).id
      executor_details = {
        email: 'ex@ample.com',
        phone: '555-867-5309'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/executors", headers: headers, params: JSON.generate(executor_details)
      expect(response.status).to eq 400
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message[:error]).to eq 'Missing or Incorrect Executor Params'
    end

    it 'ignores extra attributes' do
      user_id = create(:user).id
      executor_details = {
        email: 'ex@ample.com',
        name: 'Younger Bobby',
        phone: '555-867-5309',
        password: 'password',
        banana: 'cabana',
        foo: 'bar'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/executors", headers: headers, params: JSON.generate(executor_details)
      exec = Executor.last

      expect(exec).is_a? Executor
      expect(exec.email).to eq 'ex@ample.com'
      expect(exec.name).to eq 'Younger Bobby'
      expect(exec.phone).to eq '555-867-5309'
      expect(exec.user_id).to eq user_id
      expect{exec.password}.to raise_error(NameError)
      expect{exec.banana}.to raise_error(NameError)
      expect{exec.foo}.to raise_error(NameError)
    end
  end
end