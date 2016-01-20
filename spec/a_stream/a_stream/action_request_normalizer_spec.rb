require 'rails_helper'

describe AStream::ActionRequestNormalizer do
  subject(:normalizer) { described_class }
  let(:performer) { Anonymous.user }

  describe '.normalize_query' do
    let(:action) { Class.new(AStream::BaseAction) }
    let(:initial_query) { {property: 'initial query'} }
    let(:query_with_normalized_params) { {my_param: 'normalized'} }
    let(:query_with_filtered_included_resources) { {include: 'filtered'} }

    specify do
      expect(normalizer).to receive(:_normalize_params)
        .with(action, performer, initial_query)
        .and_return(query_with_normalized_params).ordered

      expect(normalizer).to receive(:_filter_included_resources)
        .with(action, performer, query_with_normalized_params)
        .and_return(query_with_filtered_included_resources).ordered
    end

    after do
      query = normalizer.normalize_query(action, performer, initial_query)
      expect(query).to eq(query_with_filtered_included_resources)
    end
  end

  describe '._normalize_params' do
    context 'included resources requested' do
      context 'param :included is not permitted' do
        let(:action) { Class.new(AStream::BaseAction) }

        context 'one type of included resources requested' do
          specify do
            expect(normalizer._normalize_params(action, performer, included: :notes)).to eq('included' => [:notes])
          end
        end

        context 'few types of included resources requested' do
          specify do
            expect(normalizer._normalize_params(action, performer, included: [:notes])).to eq('included' => [:notes])
          end
        end
      end
    end
  end

  describe '._filter_included_resources' do
    context 'allowed included resources are not specified' do
      let(:action) { Class.new(AStream::BaseAction) }
      let(:query) { {name: 'Test user', included: ['contacts', 'notes']} }
      let(:filtered_query) { {name: 'Test user'} }
      specify { expect(normalizer._filter_included_resources(action, performer, query)).to eq(filtered_query) }
    end

    context 'allowed included resources are specified' do
      let(:action) do
        Class.new(AStream::BaseAction) do
          included_resources :notes, :contacts
        end
      end

      context 'included resources are not requested' do
        let(:query) { {name: 'Test user'} }
        specify { expect(normalizer._filter_included_resources(action, performer, query)).to eq(query) }
      end

      context 'given allowed included resources' do
        let(:query) { {name: 'Test user', included: ['contacts', 'notes']} }
        let(:filtered_query) { {name: 'Test user', included: [:contacts, :notes]} }
        specify { expect(normalizer._filter_included_resources(action, performer, query)).to eq(filtered_query) }
      end

      context 'given some restricted included resources' do
        let(:query) { {name: 'Test user', included: ['contacts', 'notes', 'pictures']} }
        let(:filtered_query) { {name: 'Test user', included: [:contacts, :notes]} }
        specify { expect(normalizer._filter_included_resources(action, performer, query)).to eq(filtered_query) }
      end
    end
  end
end
