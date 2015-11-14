require 'rails_helper'

describe ApplicationController do
  it { is_expected.to rescue_from(ActiveRecord::RecordInvalid).with(:process_failed_validation) }

  describe 'validation errors' do
    controller(described_class) do
      def index
        User.create!
      end
    end

    before { get(:index) }

    it 'returns json with errors hash' do
      response_body = JSON.parse(response.body)
      expect(response_body['errors']).not_to be_nil
    end
  end

  describe '#render_modal' do
    controller(described_class) do
      def index
        render_modal('Test modal')
      end
    end

    before do
      allow(subject).to receive(:render_to_string).and_return 'Test content'
    end

    it 'returns json with modal title and html' do
      get(:index)

      response_body = JSON.parse(response.body)
      expect(response_body).to include('title' => 'Test modal', 'html' => 'Test content')
    end
  end
end
