describe ActionRequest do
  before do
    module Actions; module Test; class Test; end; end; end
    module Test; class Test; end; end

    allow(ActionQueryNormalizer).to receive(:normalize_query).and_return({})
  end

  context 'not given required data' do
    specify { expect { described_class.new(runner: Actions::Test::Test, type: :get) }.to raise_error(ArgumentError) }
    specify { expect { described_class.new(runner: Actions::Test::Test, query: {}) }.to raise_error(ArgumentError) }
    specify { expect { described_class.new(type: :get, query: {}) }.to raise_error(ArgumentError) }
  end

  context 'given required data' do
    subject { described_class.new(runner: Actions::Test::Test, type: :get, query: {}) }

    specify { expect(subject.runner).to eq(Actions::Test::Test) }
    specify { expect(subject.type).to eq(:get) }
    specify { expect(subject.query).to eq({}) }

    context 'given valid type' do
      context 'given get type' do
        subject { described_class.new(runner: Actions::Test::Test, type: :get, query: {}) }
        specify { expect(subject.type).to eq(:get) }
      end

      context 'given post type' do
        subject { described_class.new(runner: Actions::Test::Test, type: :post, query: {}) }
        specify { expect(subject.type).to eq(:post) }
      end
    end

    context 'given invalid type' do
      it 'throws argument error' do
        expect { described_class.new(runner: Actions::Test::Test,
                                     type: :update,
                                     query: {}) }.to raise_error(ArgumentError,
                                                                 /ActionRequest#type should be either :get or :post, but :update is provided/)
      end
    end

    context 'given valid action runner' do
      subject { described_class.new(runner: Actions::Test::Test, type: :get, query: {}) }
      specify { expect(subject.runner).to eq(Actions::Test::Test) }
    end

    context 'given invalid action runner' do
      context 'action runner is not from Actions namespace' do
        it 'throws argument error' do
          expect { described_class.new(runner: Test::Test, type: :get, query: {}) }.to raise_error(ArgumentError,
                                                                                                   /ActionRequest#runner should be an Action class/)
        end
      end

      context 'action runner is not a class' do
        it 'throws argument error' do
          expect { described_class.new(runner: 'test#test', type: :get, query: {}) }.to raise_error(ArgumentError,
                                                                                                   /ActionRequest#runner should be an Action class/)
        end
      end
    end
  end

  describe '#query' do
    before do
      allow(ActionQueryNormalizer).to receive(:normalize_query).and_return(normalized: 'query')
    end

    subject { described_class.new(runner: Actions::Test::Test, type: :get, query: {dirty: 'query'}) }

    it 'always returns normalized query' do
      expect(ActionQueryNormalizer).to receive(:normalize_query).with(Actions::Test::Test, dirty: 'query').once
      subject.query
      subject.query
      expect(subject.query).to eq(normalized: 'query')
    end
  end
end
