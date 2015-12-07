require 'rails_helper'
require 'a_stream/a_stream_helper'

describe AStream::Response do
  context 'status and body are provided' do
    subject(:response) { described_class.new(status: :ok, body: 123, message: 'Test') }
    specify do
      expect(response.status).to eq(:ok)
      expect(response.body).to eq(123)
      expect(response.message).to eq('Test')
    end
  end

  context 'status is not provided' do
    subject(:response) { described_class.new(body: 123) }
    specify do
      expect(response.status).to eq(:ok)
    end
  end

  context 'body is not provided' do
    subject(:response) { described_class.new(status: :ok) }
    specify do
      expect(response.body).to eq(nil)
    end
  end

  context 'message is not provided' do
    subject(:response) { described_class.new(status: :ok, body: 123) }
    specify do
      expect(response.message).to eq(nil)
    end
  end
end
