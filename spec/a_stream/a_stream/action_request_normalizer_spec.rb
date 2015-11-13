require 'rails_helper'

describe AStream::ActionRequestNormalizer do
  subject(:normalizer) { described_class }
  let(:performer) { Anonymous.user }

  describe '.normalize_query' do
    let(:action) { Class.new(AStream::BaseAction) }
    let(:initial_query) { {property: 'initial query'} }
    let(:query_with_filtered_params) { {property: 'filtered'} }
    let(:query_with_filtered_included_resources) { {include: 'filtered'} }

    before do
      allow(normalizer).to receive(:_filter_params).and_return(query_with_filtered_params)
      allow(normalizer).to receive(:_filter_included_resources).and_return(query_with_filtered_included_resources)
    end

    specify do
      expect(normalizer).to receive(:_filter_params).with(action, performer, initial_query).ordered
      expect(normalizer).to receive(:_filter_included_resources).with(action, performer, query_with_filtered_params).ordered
    end

    after do
      query = normalizer.normalize_query(action, performer, initial_query)
      expect(query).to eq(query_with_filtered_included_resources)
    end
  end

  describe '._filter_params' do
    context 'permitted params are not specified for action' do
      let(:action) { Class.new(AStream::BaseAction) { def self.to_s; 'TestAction' end } }
      specify do
        expect { normalizer._filter_params(action, performer, {}) }
          .to raise_error(AStream::QueryParamsNotSpecified, /Please specify permitted query params for action TestAction/)
      end
    end

    context 'permitted params are specified for action' do
      let(:action) do
        Class.new(AStream::BaseAction) do
          query_params :name, :email, :phone, contacts: []
        end
      end

      context 'given restricted param' do
        let(:query) { {name: 'Test User', credit_card: '1234567'} }
        let(:filtered_query) { {name: 'Test User'} }
        specify { expect(normalizer._filter_params(action, performer, query)).to eq(filtered_query) }

      end

      context 'given valid included resources keys' do
        let(:query) { {name: 'Test User', credit_card: '1234567', included: ['notes', 'contacts']} }
        let(:filtered_query) { {name: 'Test User', included: ['notes', 'contacts']} }
        specify { expect(normalizer._filter_params(action, performer, query)).to eq(filtered_query) }
      end

      context 'given invalid included resources keys' do
        let(:query) { {name: 'Test User', credit_card: '1234567', included: [['notes'], 'contacts']} }
        let(:filtered_query) { {name: 'Test User'} }
        specify { expect(normalizer._filter_params(action, performer, query)).to eq(filtered_query) }
      end

      context 'given non-scalar value' do
        let(:query) { {name: 'Test User', email: ['test@mail.com']} }
        let(:filtered_query) { {name: 'Test User'} }
        specify { expect(normalizer._filter_params(action, performer, query)).to eq(filtered_query) }
      end

      context 'given allowed array of scalar values' do
        let(:query) { {name: 'Test User', contacts: ['test@mail.com', 'twitter.com/testuser']} }
        let(:filtered_query) { {name: 'Test User', contacts: ['test@mail.com', 'twitter.com/testuser']} }
        specify { expect(normalizer._filter_params(action, performer, query)).to eq(filtered_query) }
      end

      context 'given allowed array of with non-scalar values' do
        let(:query) { {name: 'Test User', contacts: [['test@mail.com'], 'twitter.com/testuser']} }
        let(:filtered_query) { {name: 'Test User'} }
        specify { expect(normalizer._filter_params(action, performer, query)).to eq(filtered_query) }
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
