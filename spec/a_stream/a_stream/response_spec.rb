require 'rails_helper'
require 'a_stream/a_stream_helper'

describe AStream::Response do
  context 'status and body are provided' do
    subject(:response) { described_class.new(status: :ok, body: 123) }
    specify do
      expect(response.status).to eq(:ok)
      expect(response.body).to eq(123)
    end
  end

  context 'status is not provided' do
    specify do
      expect { described_class.new(body: 123) }.to raise_error(ArgumentError)
    end
  end

  context 'body is not provided' do
    subject(:response) { described_class.new(status: :ok) }
    specify do
      expect(response.status).to eq(:ok)
      expect(response.body).to eq(nil)
    end
  end
end
