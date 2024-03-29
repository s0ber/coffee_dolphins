require 'rails_helper'

describe AStream::ActionRequest do
  let(:action_type) { :get }
  subject { described_class.new(runner: Test::Test, type: action_type) }

  include_examples 'action classes definition'

  context 'not given required data' do
    specify { expect { described_class.new(type: :get) }.to raise_error(ArgumentError) }
  end

  context 'given required data' do
    subject { described_class.new(runner: Test::Test, type: action_type, performer: user, query: {test: 'query'}) }
    let(:user) { create(:user) }

    specify { expect(subject.runner).to eq(Test::Test) }
    specify { expect(subject.type).to eq(:get) }
    specify { expect(subject.query).to eq(test: 'query') }
    specify { expect(subject.performer).to eq(user) }
    specify { expect(subject.action_name).to eq('test#test') }

    context 'given valid type' do
      context 'given :get type' do
        let(:action_type) { :get }
        specify { expect(subject.type).to eq(:get) }
      end

      context 'given :post type' do
        let(:action_type) { :post }
        specify { expect(subject.type).to eq(:post) }
      end
    end

    context 'given invalid type' do
      it 'throws argument error' do
        expect { described_class.new(runner: Test::Test,
                                     type: :update,
                                     performer: user,
                                     query: {}) }.to raise_error(ArgumentError,
                                                                 /ActionRequest#type should be either :get or :post, but :update is provided/)
      end
    end

    context 'given valid action runner' do
      specify { expect(subject.runner).to eq(Test::Test) }
    end

    context 'given invalid action runner' do
      context 'action runner is not an AStream::BaseAction class' do
        it 'throws argument error' do
          expect { described_class.new(runner: Test::WrongAction) }
            .to raise_error(ArgumentError, /ActionRequest#runner should be an AStream::BaseAction class/)
        end
      end

      context 'action runner is not a class' do
        it 'throws argument error' do
          expect { described_class.new(runner: 'test#test') }
            .to raise_error(ArgumentError, /ActionRequest#runner should be an AStream::BaseAction class/)
        end
      end
    end

    context 'given piped actions' do
      let(:piped_request) { described_class.new(runner: Test::Test) }
      let(:another_piped_request) { described_class.new(runner: Test::Test) }

      subject { described_class.new(runner: Test::Test, pipe: [piped_request, another_piped_request]) }
      specify { expect(subject.piped_requests).to eq([piped_request, another_piped_request]) }

      context 'trying to set value multiple times' do
        it 'allows to set value only once' do
          subject.piped_requests = piped_request
          expect(subject.piped_requests).to eq([piped_request, another_piped_request])
        end
      end
    end
  end

  describe '#piped_requests=' do
    let(:piped_request) { described_class.new(runner: Test::Test) }
    let(:another_piped_request) { described_class.new(runner: Test::Test) }

    context 'given valid action requests' do
      context 'single action' do
        specify do
          subject.piped_requests = piped_request
          expect(subject.piped_requests).to eql(piped_request)
        end
      end

      context 'multiple actions' do
        specify do
          subject.piped_requests = [piped_request, another_piped_request]
          expect(subject.piped_requests).to eq([piped_request, another_piped_request])
        end
      end

      context 'trying to set value multiple times' do
        it 'allows to set value only once' do
          subject.piped_requests = piped_request
          subject.piped_requests = another_piped_request
          expect(subject.piped_requests).to eql(piped_request)
        end
      end
    end

    context 'invalid action requests' do
      specify { expect { subject.piped_requests = '123' }
        .to raise_error(ArgumentError, /Only ActionRequest instances can be piped/) }
      specify { expect { subject.piped_requests = [piped_request, '123'] }
        .to raise_error(ArgumentError, /Only ActionRequest instances can be piped/) }
    end
  end

  describe '#query' do
    before do
      allow(AStream::ActionRequestNormalizer).to receive(:normalize_query).and_return(normalized: 'query')
    end

    context 'query is specified' do
      subject { described_class.new(runner: Test::Test, query: {dirty: 'query'}) }

      it 'returns memoized normalized query' do
        expect(AStream::ActionRequestNormalizer).to receive(:normalize_query).with(Test::Test, nil, dirty: 'query').once
        subject.query
        subject.query
        expect(subject.query).to eq(normalized: 'query')
      end
    end

    context 'query is not specified' do
      subject { described_class.new(runner: Test::Test) }

      it 'returns empty hash' do
        expect(AStream::ActionRequestNormalizer).not_to receive(:normalize_query)
        expect(subject.query).to eq({})
      end
    end
  end

  describe '#query=' do
    before do
      Test::Test.class_eval do
        query_params :new
      end

      subject.query = {new: 'query'}
    end

    context 'request has query specified' do
      subject { described_class.new(runner: Test::Test, query: {}) }

      it 'cant override value' do
        expect(subject.query).to eq({})
      end
    end

    context 'request has not query specified' do
      subject { described_class.new(runner: Test::Test) }

      it 'sets new value' do
        expect(subject.query).to eq({new: 'query'})
      end
    end
  end
end
