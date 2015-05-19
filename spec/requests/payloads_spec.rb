require 'rails_helper'

RSpec.describe 'Github Event Payloads', type: :request do

  before do
    ENV['WEBHOOK_SECRET_TOKEN'] = 'abc123'
  end

  let(:payload) do
    {
      "payload":
      {
        "action": "opened",
        "issue": {
          "url": "https://api.github.com/repos/octocat/Hello-World/issues/1347",
          "number": 1347
        },
        "repository": {
          "id": 1296269,
          "full_name": "octocat/Hello-World",
          "owner": {
            "login": "octocat",
            "id": 1
          }
        },
        "sender": {
          "login": "octocat",
          "id": 1
        }
      }
    }.to_json
  end

  describe 'POST /payloads' do
    before do
      post payloads_path,
           payload,
           { 'Content-Type'     => 'application/json',
             'X-GitHub-Event'   => 'testing',
             'X-Hub-Signature'  => signature }
    end

    describe 'when the X-Hub-Signature header does not validate' do
      let(:signature) { '' }

      it 'returns a 500 status' do
        expect(response).to have_http_status(500)
      end

      it 'does not create an event record' do
        expect(Event.count).to eq(0)
      end
    end

    describe 'when the X-Hub-Signature header validates' do
      let(:signature) do
        digest = OpenSSL::Digest.new('sha1')
        'sha1=' + OpenSSL::HMAC.hexdigest(digest, ENV['WEBHOOK_SECRET_TOKEN'], payload)
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(200)
      end

      it 'creates an event record' do
        expect(Event.count).to eq(1)
      end
    end
  end
end
