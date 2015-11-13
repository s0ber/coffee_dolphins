require 'rails_helper'

describe ActionRequestNormalizer do
  subject(:normalizer) { described_class }

  describe '.normalize_query' do
    let(:action) { Class.new }
    let(:initial_query) { {property: 'initial query'} }
    let(:query_with_filtered_attrs) { {property: 'filtered'} }
    let(:query_with_filtered_included_resources) { {include: 'filtered'} }
    let(:query_with_filtered_child_actions) { {child_action: 'filtered'} }

    before do
      allow(normalizer).to receive(:_filter_attributes).and_return(query_with_filtered_attrs)
      allow(normalizer).to receive(:_filter_included_resources).and_return(query_with_filtered_included_resources)
      allow(normalizer).to receive(:_filter_child_actions).and_return(query_with_filtered_child_actions)
    end

    specify do
      expect(normalizer).to receive(:_filter_attributes).with(action, initial_query).ordered
      expect(normalizer).to receive(:_filter_included_resources).with(action, query_with_filtered_attrs).ordered
      expect(normalizer).to receive(:_filter_child_actions).with(action, query_with_filtered_included_resources).ordered
    end

    after do
      query = normalizer.normalize_query(action, initial_query)
      expect(query).to eq(query_with_filtered_child_actions)
    end
  end

  describe '._filter_attributes' do
    let(:action) do
      Class.new do
        def self.query_attributes
          [:name, :email, :phone, contacts: []]
        end
      end
    end

    context 'permitted attrs are not specified for action' do
      let(:action) { Class.new }
      specify do
        expect { normalizer._filter_attributes(action, {}) }.to raise_error(NoMethodError,
                                                                              /Allowed query attributes are not specified for action/)
      end
    end

    context 'permitted attrs are specified for action' do
      context 'given restricted param' do
        let(:query) { {name: 'Test User', credit_card: '1234567'} }
        let(:filtered_query) { {name: 'Test User'}.with_indifferent_access }
        specify { expect(normalizer._filter_attributes(action, query)).to eq(filtered_query) }

      end

      context 'given valid included resources keys' do
        let(:query) { {name: 'Test User', credit_card: '1234567', included: ['notes', 'contacts']} }
        let(:filtered_query) { {name: 'Test User', included: ['notes', 'contacts']}.with_indifferent_access }
        specify { expect(normalizer._filter_attributes(action, query)).to eq(filtered_query) }
      end

      context 'given invalid included resources keys' do
        let(:query) { {name: 'Test User', credit_card: '1234567', included: [['notes'], 'contacts']} }
        let(:filtered_query) { {name: 'Test User'}.with_indifferent_access }
        specify { expect(normalizer._filter_attributes(action, query)).to eq(filtered_query) }
      end

      context 'given valid child actions' do
        let(:query) { {name: 'Test User', credit_card: '1234567', child_actions: ['test#child_action_1', 'test#child_action_2']} }
        let(:filtered_query) { {name: 'Test User', child_actions: ['test#child_action_1', 'test#child_action_2']}.with_indifferent_access }
        specify { expect(normalizer._filter_attributes(action, query)).to eq(filtered_query) }
      end

      context 'given invalid child actions' do
        let(:query) { {name: 'Test User', credit_card: '1234567', child_actions: [['test#child_action_1'], 'test#child_action_2']} }
        let(:filtered_query) { {name: 'Test User'}.with_indifferent_access }
        specify { expect(normalizer._filter_attributes(action, query)).to eq(filtered_query) }
      end

      context 'given non-scalar value' do
        let(:query) { {name: 'Test User', email: ['test@mail.com']} }
        let(:filtered_query) { {name: 'Test User'}.with_indifferent_access }
        specify { expect(normalizer._filter_attributes(action, query)).to eq(filtered_query) }
      end

      context 'given allowed array of scalar values' do
        let(:query) { {name: 'Test User', contacts: ['test@mail.com', 'twitter.com/testuser']} }
        let(:filtered_query) { {name: 'Test User', contacts: ['test@mail.com', 'twitter.com/testuser']}.with_indifferent_access }
        specify { expect(normalizer._filter_attributes(action, query)).to eq(filtered_query) }
      end

      context 'given allowed array of with non-scalar values' do
        let(:query) { {name: 'Test User', contacts: [['test@mail.com'], 'twitter.com/testuser']} }
        let(:filtered_query) { {name: 'Test User'}.with_indifferent_access }
        specify { expect(normalizer._filter_attributes(action, query)).to eq(filtered_query) }
      end
    end
  end

  describe '._filter_included_resources' do
    context 'allowed included resources are not specified' do
      let(:action) { Class.new }
      let(:query) { {name: 'Test user', included: ['contacts', 'notes']} }
      let(:filtered_query) { {name: 'Test user'} }
      specify { expect(normalizer._filter_included_resources(action, query)).to eq(filtered_query) }
    end

    context 'allowed included resources are specified' do
      let(:action) do
        Class.new do
          def self.included_resources
            [:notes, :contacts]
          end
        end
      end

      context 'given allowed included resources' do
        let(:query) { {name: 'Test user', included: ['contacts', 'notes']} }
        let(:filtered_query) { {name: 'Test user', included: [:contacts, :notes]} }
        specify { expect(normalizer._filter_included_resources(action, query)).to eq(filtered_query) }
      end

      context 'given some restricted included resources' do
        let(:query) { {name: 'Test user', included: ['contacts', 'notes', 'pictures']} }
        let(:filtered_query) { {name: 'Test user', included: [:contacts, :notes]} }
        specify { expect(normalizer._filter_included_resources(action, query)).to eq(filtered_query) }
      end
    end
  end

  describe '._filter_child_actions' do
    let!(:child_action_1) do
      module Actions
        module TestNamespace; class ChildAction1; end; end
      end
    end
    let!(:child_action_2) do
      module Actions
        module TestNamespace; class ChildAction2; end; end
      end
    end

    context 'allowed child actions are specified' do
      let!(:action) do
        Class.new  do
          def self.child_actions
            [Actions::TestNamespace::ChildAction1, Actions::TestNamespace::ChildAction2]
          end
        end
      end

      context 'given valid actions' do
        let(:query) { {name: 'Test user', child_actions: ['test_namespace#child_action_1', 'test_namespace#child_action_2'] } }
        it 'maps child actions strings to actual actions classes' do
          expect(normalizer._filter_child_actions(action, query)).to eq(name: 'Test user',
                                                                        child_actions: [Actions::TestNamespace::ChildAction1,
                                                                                        Actions::TestNamespace::ChildAction2])
        end
      end

      context 'given invalid actions' do
        let(:query) { {name: 'Test user', child_actions: ['test_namespace#child_action_1', 'wrong_namespace#wrong_action'] } }

        it 'maps child actions strings to actual actions classes, ignoring those, which are not found' do
          expect(normalizer._filter_child_actions(action, query)).to eq(name: 'Test user',
                                                                        child_actions: [Actions::TestNamespace::ChildAction1])
        end
      end
    end

    context 'allowed child actions are not specified' do
      let(:action) { Class.new }
      let(:query) { {name: 'Test user', child_actions: ['test_namespace#child_action_1', 'test_namespace#child_action_2'] } }

      context 'given valid actions' do
        specify { expect(normalizer._filter_child_actions(action, query)).to eq(name: 'Test user') }
      end
    end
  end
end
