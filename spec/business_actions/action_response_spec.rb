require 'rails_helper'

describe ActionResponse do
  subject { described_class.new(body: body, request: request) }

  let(:request) { double('request', runner: action) }
  let(:action) { double('action', to_s: 'TestAction') }
  let(:body) { create_list(:user, 5, :collection) }

  context 'no status provided' do
    specify { expect(subject.status).to eq(:ok) }
    specify  { expect(subject.request).to eq(request) }
    specify  { expect(subject.unsafe_body).to eq(body) }
  end

  context 'valid status is provided' do
    subject { described_class.new(body: body, request: request, status: :unprocessable_entity) }
    specify  { expect(subject.status).to eq(:unprocessable_entity) }
  end

  context 'invalid status is provided' do
    specify do
      expect { described_class.new(body: body, request: request, status: :wrong_status) }
        .to raise_error(ArgumentError, /Wrong response status is specified/)
    end
  end

  context 'non-enumerate response body is provided' do
    let(:body) { create(:user) }
    specify do
      expect { described_class.new(body: body, request: request) }
        .to raise_error(ArgumentError,
                        /Action should always respond with collection, but non-iterateble response specified for action TestAction./)
    end
  end

  describe '#body' do
    before do
      allow(ActionResponseNormalizer).to receive(:normalize_body).and_return(['normalized', 'response'])
    end

    it 'returns memoized normalized body' do
      expect(ActionResponseNormalizer).to receive(:normalize_body).with(subject.request, subject).once
    end

    after do
      subject.body
      subject.body
      expect(subject.body).to eq(['normalized', 'response'])
    end
  end
end
