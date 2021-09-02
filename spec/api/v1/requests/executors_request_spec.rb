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

  describe 'update' do
    it 'can update an executor' do
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

      updated_executor_details = {
        email: 'new@mail.com',
        name: 'Medium Bobby',
        phone: '111-222-3333'
      }
      patch "/api/v1/users/#{user_id}/executors/#{exec.id}", headers: headers, params: JSON.generate(updated_executor_details)

      edited_exec = Executor.find(exec.id)

      expect(edited_exec).is_a? Executor
      expect(edited_exec.email).to eq 'new@mail.com'
      expect(edited_exec.name).to eq 'Medium Bobby'
      expect(edited_exec.phone).to eq '111-222-3333'
      expect(edited_exec.user_id).to eq user_id
    end

    it 'can update a single attribute' do
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

      updated_executor_details = {
        email: 'new@mail.com'
      }
      patch "/api/v1/users/#{user_id}/executors/#{exec.id}", headers: headers, params: JSON.generate(updated_executor_details)

      edited_exec = Executor.find(exec.id)

      expect(edited_exec).is_a? Executor
      expect(edited_exec.email).to eq 'new@mail.com'
      expect(edited_exec.name).to eq 'Younger Bobby'
      expect(edited_exec.phone).to eq '555-867-5309'
      expect(edited_exec.user_id).to eq user_id
    end

    it 'can not set email to nil' do
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

      updated_executor_details = {
        email: nil
      }
      patch "/api/v1/users/#{user_id}/executors/#{exec.id}", headers: headers, params: JSON.generate(updated_executor_details)

      expect(response.status).to eq 400

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:error]).to eq 'Executor name or email cannot be empty'
    end
  end

  describe 'delete' do
    it 'deletes an executor' do
      user_id = create(:user).id
      executor_details = {
        email: 'ex@ample.com',
        name: 'Younger Bobby',
        phone: '555-867-5309'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/executors", headers: headers, params: JSON.generate(executor_details)
      exec = Executor.last

      delete "/api/v1/users/#{user_id}/executors/#{exec.id}"
      expect(response.status).to eq 204

      expect{Executor.find(exec.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'index' do
    it 'returns one executor' do
      user_id = create(:user).id
      executor_details = {
        email: 'ex@ample.com',
        name: 'Younger Bobby',
        phone: '555-867-5309'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/executors", headers: headers, params: JSON.generate(executor_details)
      exec = Executor.last

      get "/api/v1/users/#{user_id}/executors"
      expect(response.status).to eq 200

      executors = JSON.parse(response.body, symbolize_names: true)

      expect(executors).is_a? Hash
      expect(executors).to have_key(:data)
      expect(executors[:data]).is_a? Array
      expect(executors[:data].length).to eq 1
      expect(executors[:data][0]).is_a? Hash
      expect(executors[:data][0]).to have_key(:id)
      expect(executors[:data][0][:id]).is_a? String
      expect(executors[:data][0]).to have_key(:type)
      expect(executors[:data][0][:type]).to eq 'executor'
      expect(executors[:data][0]).to have_key(:attributes)
      expect(executors[:data][0][:attributes]).is_a? Hash
      expect(executors[:data][0][:attributes]).to have_key(:email)
      expect(executors[:data][0][:attributes][:email]).to eq 'ex@ample.com'
      expect(executors[:data][0][:attributes]).to have_key(:name)
      expect(executors[:data][0][:attributes][:name]).to eq 'Younger Bobby'
      expect(executors[:data][0][:attributes]).to have_key(:phone)
      expect(executors[:data][0][:attributes][:phone]).to eq '555-867-5309'
    end

    it 'returns an empty array if no executors' do
      user_id = create(:user).id
      get "/api/v1/users/#{user_id}/executors"
      expect(response.status).to eq 200

      empty = JSON.parse(response.body, symbolize_names: true)
      expect(empty).is_a? Hash
      expect(empty).to have_key(:data)
      expect(empty[:data]).to eq([])
      expect(empty).not_to have_key(:id)
      expect(empty).not_to have_key(:type)
      expect(empty).not_to have_key(:attributes)
    end
  end
end