require 'rails_helper'
require 'a_stream/a_stream_helper'

describe AStream::ActionResponse do
  subject { described_class.new(body: body, request: request) }

  let(:request) { instance_double('AStream::ActionRequest', runner: action) }
  let(:action) { Class.new(AStream::BaseAction) { def self.to_s; 'TestAction' end } }
  let(:body) { build_stubbed_list(:user, 2, :collection) }

  context 'no status provided' do
    specify { expect(subject.status).to eq(:ok) }
    specify { expect(subject.request).to eq(request) }
    specify { expect(subject.unsafe_body).to eq(body) }
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
    context 'simple action requested' do
      let(:body) { build_stubbed(:user) }

      specify do
        expect { described_class.new(body: body, request: request) }.not_to raise_error
      end
    end

    context 'collection action requested' do
      let(:body) { build_stubbed(:user) }
      let(:action) { Class.new(AStream::CollectionAction) { def self.to_s; 'TestAction' end } }

      specify do
        expect { described_class.new(body: body, request: request) }
          .to raise_error(ArgumentError, /Collection action should always respond with collection, but non-iterateble response specified for action TestAction./)
      end
    end
  end

  describe '#body' do
    let(:normalizer) { double('ActionResponseNormalizer', normalize: ['normalized', 'response']) }

    before do
      allow(subject).to receive(:normalizer).and_return(normalizer).once
    end

    after do
      subject.body
      subject.body
      expect(subject.body).to eq(['normalized', 'response'])
    end
  end
end
