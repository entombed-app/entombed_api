require 'rails_helper'

RSpec.describe 'Recipient Requests' do
  describe 'create' do
    it 'creates a recipient' do
      user_id = create(:user).id
      recipient_details = {
        email: 'test@test.com',
        name: 'test name'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)
      recip = Recipient.last

      expect(recip).is_a? Recipient
      expect(recip.email).to eq 'test@test.com'
      expect(recip.name).to eq 'test name'
      expect(recip.user_id).to eq user_id
    end

    it 'returns serialized recipient details' do
        user_id = create(:user).id
        recipient_details = {
          email: 'test@test.com',
          name: 'test name'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)
      recip = JSON.parse(response.body, symbolize_names: true)

      expect(recip).is_a? Hash
      expect(recip).to have_key(:data)
      expect(recip[:data]).to have_key(:id)
      expect(recip[:data][:id]).is_a? String
      expect(recip[:data]).to have_key(:type)
      expect(recip[:data][:type]).to eq 'recipient'
      expect(recip[:data]).to have_key(:attributes)
      expect(recip[:data][:attributes]).is_a? Hash
      expect(recip[:data][:attributes]).to have_key(:email)
      expect(recip[:data][:attributes][:email]).to eq 'test@test.com'
      expect(recip[:data][:attributes]).to have_key(:name)
      expect(recip[:data][:attributes][:name]).to eq 'test name'
    end

    it 'does not create without email' do
      user_id = create(:user).id
      recipient_details = {
        name: 'test name'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)
      expect(response.status).to eq 400
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message[:error]).to eq 'Missing or Incorrect Recipient Params'
    end

    it 'does not create without name' do
      user_id = create(:user).id
      recipient_details = {
        email: 'test@test.com'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)
      expect(response.status).to eq 400
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message[:error]).to eq 'Missing or Incorrect Recipient Params'
    end

    it 'ignores extra attributes' do
      user_id = create(:user).id
      recipient_details = {
        email: 'test@test.com',
        name: 'test name',
        phone: '555-867-5309',
        password: 'password',
        banana: 'cabana',
        foo: 'bar'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)
      recip = Recipient.last

      expect(recip).is_a? Recipient
      expect(recip.email).to eq 'test@test.com'
      expect(recip.name).to eq 'test name'
      expect(recip.user_id).to eq user_id
      expect{recip.password}.to raise_error(NameError)
      expect{recip.banana}.to raise_error(NameError)
      expect{recip.foo}.to raise_error(NameError)
    end
  end

  describe 'update' do
    it 'can update an recipient' do
      user_id = create(:user).id
      recipient_details = {
        email: 'test@test.com',
        name: 'test name'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)

      recip = Recipient.last
      expect(recip).is_a? Recipient
      expect(recip.email).to eq 'test@test.com'
      expect(recip.name).to eq 'test name'
      expect(recip.user_id).to eq user_id

      updated_recipient_details = {
        email: 'test 2',
        name: 'test 2'
      }
      patch "/api/v1/users/#{user_id}/recipients/#{recip.id}", headers: headers, params: JSON.generate(updated_recipient_details)

      edited_recip = Recipient.find(recip.id)

      expect(edited_recip).is_a? Recipient
      expect(edited_recip.email).to eq 'test 2'
      expect(edited_recip.name).to eq 'test 2'
      expect(edited_recip.user_id).to eq user_id
    end

    it 'can update a single attribute' do
      user_id = create(:user).id
      recipient_details = {
        email: 'test@test.com',
        name: 'test name'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)

      recip = Recipient.last
      expect(recip).is_a? Recipient
      expect(recip.email).to eq 'test@test.com'
      expect(recip.name).to eq 'test name'
      expect(recip.user_id).to eq user_id

      updated_recipient_details = {
        email: 'new@mail.com'
      }
      patch "/api/v1/users/#{user_id}/recipients/#{recip.id}", headers: headers, params: JSON.generate(updated_recipient_details)

      edited_recip = Recipient.find(recip.id)

      expect(edited_recip).is_a? Recipient
      expect(edited_recip.email).to eq 'new@mail.com'
      expect(edited_recip.name).to eq 'test name'
      expect(edited_recip.user_id).to eq user_id
    end

    it 'can not set email to nil' do
      user_id = create(:user).id
      recipient_details = {
        email: 'test@test.com',
        name: 'test name'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)

      recip = Recipient.last
      expect(recip).is_a? Recipient
      expect(recip.email).to eq 'test@test.com'
      expect(recip.name).to eq 'test name'
      expect(recip.user_id).to eq user_id

      updated_recipient_details = {
        email: nil
      }
      patch "/api/v1/users/#{user_id}/recipients/#{recip.id}", headers: headers, params: JSON.generate(updated_recipient_details)

      expect(response.status).to eq 400

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:error]).to eq 'Recipient name or email cannot be empty'
    end
  end

  describe 'delete' do
    it 'deletes an recipient' do
      user_id = create(:user).id
      recipient_details = {
        email: 'test@test.com',
        name: 'test name'
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)
      recip = Recipient.last

      delete "/api/v1/users/#{user_id}/recipients/#{recip.id}"
      expect(response.status).to eq 204

      expect{Recipient.find(recip.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'index' do
    it 'returns one recipient' do
      user_id = create(:user).id
      recipient_details = {
        email: 'test@test.com',
        name: 'test name',
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)
      recip = Recipient.last

      get "/api/v1/users/#{user_id}/recipients"
      expect(response.status).to eq 200

      recipients = JSON.parse(response.body, symbolize_names: true)

      expect(recipients).is_a? Hash
      expect(recipients).to have_key(:data)
      expect(recipients[:data]).is_a? Array
      expect(recipients[:data].length).to eq 1
      expect(recipients[:data][0]).is_a? Hash
      expect(recipients[:data][0]).to have_key(:id)
      expect(recipients[:data][0][:id]).is_a? String
      expect(recipients[:data][0]).to have_key(:type)
      expect(recipients[:data][0][:type]).to eq 'recipient'
      expect(recipients[:data][0]).to have_key(:attributes)
      expect(recipients[:data][0][:attributes]).is_a? Hash
      expect(recipients[:data][0][:attributes]).to have_key(:email)
      expect(recipients[:data][0][:attributes][:email]).to eq 'test@test.com'
      expect(recipients[:data][0][:attributes]).to have_key(:name)
      expect(recipients[:data][0][:attributes][:name]).to eq 'test name'
    end

    it 'returns multiple recipients' do
      user_id = create(:user).id
      recipient_details = {
        email: 'test@test.com',
        name: 'test name'
      }
      next_rec = {
        email: 'ex@test.com',
        name: 'test name',
      }
      third_rec = {
        email: 'exam@ple.com',
        name: 'test name',
      }
      headers = {"CONTENT_TYPE"  => 'application/json'}
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(recipient_details)
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(next_rec)
      post "/api/v1/users/#{user_id}/recipients", headers: headers, params: JSON.generate(third_rec)

      get "/api/v1/users/#{user_id}/recipients"
      expect(response.status).to eq 200

      recipients = JSON.parse(response.body, symbolize_names: true)

      expect(recipients).is_a? Hash
      expect(recipients).to have_key(:data)
      expect(recipients[:data]).is_a? Array
      expect(recipients[:data].length).to eq 3
      recipients[:data].each do |recip|
        expect(recip).to have_key(:id)
        expect(recip[:id]).is_a? String
        expect(recip).to have_key(:type)
        expect(recip[:type]).to eq 'recipient'
        expect(recip).to have_key(:attributes)
        expect(recip[:attributes]).is_a? Hash
        expect(recip[:attributes]).to have_key(:email)
        expect(recip[:attributes][:email]).is_a? String
        expect(recip[:attributes]).to have_key(:name)
        expect(recip[:attributes][:name]).is_a? String
      end
      
    end

    it 'returns an empty array if no recipients' do
      user_id = create(:user).id
      get "/api/v1/users/#{user_id}/recipients"
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