class PayloadsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :verify_signature

  def create
    if Event.create(name: request.headers['X-GitHub-Event'],
                    payload: payload)
      head :ok
    else
      head :not_acceptable
    end
  end

  private

  def payload
    params.require(:payload)
  end

  def verify_signature
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['WEBHOOK_SECRET_TOKEN'], request.body.read)
    render status: 500, text: "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.headers['X-Hub-Signature'])
  end
end
