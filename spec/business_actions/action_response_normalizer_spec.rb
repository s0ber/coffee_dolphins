require 'rails_helper'
require 'a_stream_helper'

describe ActionResponseNormalizer do
  subject(:normalizer) { described_class.new(request, response) }
  let(:request) { instance_double('ActionRequest', performer: performer, runner: action, query: nil) }
  let(:response) { instance_double('ActionResponse', unsafe_body: unsafe_body) }
  let(:action) { double('action') }
  let(:performer) { double('performer') }
  let(:unsafe_body) { ['unsafe', 'body'] }

  describe '#normalize_body' do
    before do
      allow(normalizer).to receive(:filter_resources).and_return(['filtered', 'resources'])
      allow(normalizer).to receive(:serialize_resources).and_return(['serialized', 'resources'])
      allow(normalizer).to receive(:filter_included_resources).and_return(['filtered', 'included', 'resources'])
    end

    context 'query requests included resources' do
      let(:request) { instance_double('ActionRequest', performer: 'fake_performer', runner: 'fake_action', query: {included: [:test]}) }

      specify do
        expect(normalizer).to receive(:filter_resources)
          .with(no_args)
          .and_return(['filtered', 'resources'])
          .ordered

        expect(normalizer).to receive(:serialize_resources)
          .with(resources: ['filtered', 'resources'])
          .and_return(['serialized', 'resources'])
          .ordered

        expect(normalizer).to receive(:filter_included_resources)
          .with([:test], ['serialized', 'resources'])
          .and_return(['filtered', 'included', 'resources'])
          .ordered
      end

      after do
        expect(normalizer.normalize_body).to eq(['filtered', 'included', 'resources'])
      end
    end

    context 'query does not request included resources' do
      let(:request) { instance_double('ActionRequest', performer: 'fake_performer', runner: 'fake_action', query: nil) }

      specify do
        expect(normalizer).to receive(:filter_resources)
          .with(no_args)
          .and_return(['filtered', 'resources'])
          .ordered

        expect(normalizer).to receive(:serialize_resources)
          .with(resources: ['filtered', 'resources'])
          .and_return(['serialized', 'resources'])
          .ordered
      end

      after do
        expect(normalizer.normalize_body).to eq(['serialized', 'resources'])
      end
    end
  end

  describe '.filter_resources' do
    let(:unsafe_body) { (1..10) }

    context 'permit check specified' do
      before { allow(action).to receive(:permit) { |performer, item| item % 2 == 0 } }
      it 'reduces collection to an array, which satisfy permit rules' do
        expect(normalizer.filter_resources).to eq([2, 4, 6, 8, 10])
      end
    end

    context 'permit check not specified' do
      it 'reduces collection to an empty array' do
        expect(normalizer.filter_resources).to eq([])
      end
    end
  end

  describe 'serialize_resources' do
    let(:admin) { create(:user, :admin) }
    let(:moder) { create(:user, :moder) }

    context 'safe attributes specified for action' do
      let(:action) { double('action', safe_attributes: [:full_name, :gender]) }

      context 'resources are serializable' do
        it 'leaves only safe attributes and id' do
          expect(normalizer.serialize_resources(resources: [admin, moder]))
            .to match([{id: an_instance_of(Fixnum), full_name: 'Admin User', gender: true},
                       {id: an_instance_of(Fixnum), full_name: 'Moder User', gender: false}])
        end
      end

      context 'resources are valid hashes' do
        let(:admin) { {id: 1, full_name: 'Admin User', secret_info: 'Likes ice-cream'} }
        let(:moder) { {id: 2, full_name: 'Moder User', secret_info: 'Likes vodka'} }

        it 'leaves only safe attributes and id' do
          expect(normalizer.serialize_resources(resources: [admin, moder]))
            .to match([{id: an_instance_of(Fixnum), full_name: 'Admin User'}, {id: an_instance_of(Fixnum), full_name: 'Moder User'}])
        end
      end

      context 'given non-valid safe attributes' do
        let(:action) { double('action', safe_attributes: [:full_name, :gender, [:invalid_attribute]]) }
        it 'ignores them' do
          expect(normalizer.serialize_resources(resources: [admin, moder]))
            .to match([{id: an_instance_of(Fixnum), full_name: 'Admin User', gender: true},
                       {id: an_instance_of(Fixnum), full_name: 'Moder User', gender: false}])
        end
      end
    end

    context 'safe attributes is not an array' do
      let(:action) { double('action', safe_attributes: 42, to_s: 'TestAction') }
      specify do
        expect { normalizer.serialize_resources(resources: [admin, moder]) }
          .to raise_error(AStream::SafeAttributesNotSpecified,
                          /Safe attributes for action TestAction are not valid array/)
      end
    end

    context 'safe attributes are not specified for action' do
      let(:action) { double('action', to_s: 'TestAction') }
      specify do
        expect { normalizer.serialize_resources(resources: [admin, moder]) }
          .to raise_error(AStream::SafeAttributesNotSpecified,
                          /Please specify safe attributes for action TestAction/)
      end
    end
  end

  describe '.filter_included_resources' do
    let!(:admin) { create(:user, :admin) }
    let!(:moder) { create(:user, :moder) }
    let(:serialized_admin) { {id: 1, full_name: 'Admin User', gender: true} }
    let(:serialized_moder) { {id: 2, full_name: 'Moder User', gender: false} }
    let(:unsafe_body) { [admin, moder] }
    let(:performer) { admin }

    context 'action has allowed included resources specified' do
      let(:action) { double('action', permit: true, included_resources: [:notes], safe_attributes: [:full_name, :gender]) }
      let(:notes_action) { double('show_notes_action', safe_attributes: [:title]) }

      before do
        admin.notes << build_list(:note, 4, :zebra)
        moder.notes << build_list(:note, 4, :zebra)

        allow(AStream).to receive(:find_class).and_return(notes_action)
        allow(notes_action).to receive(:permit) do |performer, note|
          performer.admin? ? (note.title == 'Note Odd') : (note.title == 'Note Even')
        end
      end

      context 'allowed included resources requested' do
        context 'performer is admin' do
          specify do
            expect(normalizer.filter_included_resources([:notes], [serialized_admin, serialized_moder])).to match([
              {id: an_instance_of(Fixnum), full_name: 'Admin User', gender: true, notes: [
                {id: an_instance_of(Fixnum), title: 'Note Odd'},
                {id: an_instance_of(Fixnum), title: 'Note Odd'}
              ]},
              {id: an_instance_of(Fixnum), full_name: 'Moder User', gender: false, notes: [
                {id: an_instance_of(Fixnum), title: 'Note Odd'},
                {id: an_instance_of(Fixnum), title: 'Note Odd'}
              ]}
            ])
          end
        end

        context 'performer is moder' do
          let(:performer) { moder }
          specify do
            expect(normalizer.filter_included_resources([:notes], [serialized_admin, serialized_moder])).to match([
              {id: an_instance_of(Fixnum), full_name: 'Admin User', gender: true, notes: [
                {id: an_instance_of(Fixnum), title: 'Note Even'},
                {id: an_instance_of(Fixnum), title: 'Note Even'}
              ]},
              {id: an_instance_of(Fixnum), full_name: 'Moder User', gender: false, notes: [
                {id: an_instance_of(Fixnum), title: 'Note Even'},
                {id: an_instance_of(Fixnum), title: 'Note Even'}
              ]}
            ])
          end
        end
      end

      context 'non-allowed included resources requested' do
        specify do
          expect(normalizer.filter_included_resources([:notes, :secrets], [serialized_admin, serialized_moder])).to match([
            {id: an_instance_of(Fixnum), full_name: 'Admin User', gender: true, notes: [
              {id: an_instance_of(Fixnum), title: 'Note Odd'},
              {id: an_instance_of(Fixnum), title: 'Note Odd'}
            ]},
            {id: an_instance_of(Fixnum), full_name: 'Moder User', gender: false, notes: [
              {id: an_instance_of(Fixnum), title: 'Note Odd'},
              {id: an_instance_of(Fixnum), title: 'Note Odd'}
            ]}
          ])
        end
      end
    end

    context 'action has not allowed included resources specified' do
      let(:action) { double('action') }

      it 'returns provided safe collection' do
        expect(normalizer.filter_included_resources([:notes], [serialized_admin, serialized_moder]))
          .to eq([serialized_admin, serialized_moder])
      end
    end
  end
end
