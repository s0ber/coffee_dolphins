describe ActionRequest do
  context 'given required data' do
    subject { described_class.new(name: 'test#test', type: :get, query: {}) }
    specify { expect(subject.name).to eq('test#test') }
    specify { expect(subject.type).to eq(:get) }
    specify { expect(subject.query).to eq({}) }

    context 'given valid type' do
      context 'given get type' do
        subject { described_class.new(name: 'test#test', type: :get, query: {}) }
        specify { expect(subject.type).to eq(:get) }
      end

      context 'given post type' do
        subject { described_class.new(name: 'test#test', type: :post, query: {}) }
        specify { expect(subject.type).to eq(:post) }
      end
    end

    context 'given invalid type' do
      it 'throws argument error' do
        expect { described_class.new(name: 'test#test',
                                     type: :update,
                                     query: {}) }.to raise_error(ArgumentError,
                                                                 /ActionRequest#type should be either :get or :post, but :update is provided/)
      end
    end
  end

  context 'not given required data' do
    specify { expect { described_class.new(name: 'test#test', type: :get) }.to raise_error(ArgumentError) }
  end
end
