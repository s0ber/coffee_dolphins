require 'rails_helper'
require 'a_stream/a_stream_helper'

describe AStream::ActionResponseNormalizer do
  subject(:normalizer) { described_class.new(request, response) }

  let(:query) { nil }
  let(:request) { instance_double('AStream::ActionRequest', performer: performer, runner: action, query: query) }
  let(:response) { instance_double('AStream::ActionResponse', unsafe_body: unsafe_body) }
  let(:action) { Class.new(AStream::BaseAction) { def self.to_s; 'TestAction' end } }
  let(:performer) { double('performer') }
  let(:unsafe_body) { ['unsafe', 'body'] }

  describe '#normalize_body' do
    let(:request) { instance_double('AStream::ActionRequest', performer: 'fake_performer', runner: 'fake_action', query: {included: [:test]}) }

    specify do
      expect(normalizer).to receive(:serialize_body)
        .with(no_args)
        .and_return('serialized body')
        .ordered
        .once

      expect(normalizer).to receive(:permit_and_filter_response)
        .with('serialized body', 'fake_action')
        .and_return('permitted and filtered resources')
        .ordered
        .once

      expect(normalizer).to receive(:permit_and_filter_included_response)
        .with('permitted and filtered resources')
        .and_return('permitted and filtered with included resources')
        .ordered
        .once
    end

    after do
      expect(normalizer.normalize_body).to eq('permitted and filtered with included resources')
    end
  end

  describe '#serialize_body' do
    context 'included resources are not requested' do
      let(:query) { {included: []} }
      let(:admin) { build_stubbed(:user, :admin) }
      let(:moder) { build_stubbed(:user, :moder) }
      let(:serialized_admin) { admin.serializable_hash.deep_symbolize_keys }
      let(:serialized_moder) { moder.serializable_hash.deep_symbolize_keys }

      context 'response is a collection of serializable resources' do
        let(:unsafe_body) { [admin, moder] }
        specify { expect(subject.serialize_body).to eq([serialized_admin, serialized_moder]) }
      end

      context 'response is a collection of hashes' do
        let(:admin) { {id: 1, full_name: 'Admin User', secret_info: 'Likes ice-cream'} }
        let(:moder) { {id: 2, full_name: 'Moder User', secret_info: 'Likes vodka'} }
        let(:unsafe_body) { [admin, moder] }
        specify { expect(subject.serialize_body).to eq([admin, moder]) }
      end

      context 'response is a serializable resource' do
        let(:unsafe_body) { admin }
        specify { expect(subject.serialize_body).to eq(serialized_admin) }
      end

      context 'response is a hash' do
        let(:admin) { {id: 1, full_name: 'Admin User', secret_info: 'Likes ice-cream'} }
        let(:unsafe_body) { admin }
        specify { expect(subject.serialize_body).to eq(admin) }
      end

      context 'response is something else' do
        let(:unsafe_body) { 5 }
        specify { expect { subject.serialize_body }.to raise_error(AStream::CantSerializeResource) }
      end
    end

    context 'included resources are requested' do
      let(:query) { {included: [:notes]} }
      let(:admin) { build_stubbed(:user, :admin) }
      let(:moder) { build_stubbed(:user, :moder) }
      let(:serialized_admin) { admin.serializable_hash(include: [:notes]).deep_symbolize_keys }
      let(:serialized_moder) { moder.serializable_hash(include: [:notes]).deep_symbolize_keys }

      context 'response is a collection of serializable resources' do
        let(:unsafe_body) { [admin, moder] }
        specify { expect(subject.serialize_body).to eq([serialized_admin, serialized_moder]) }
      end

      context 'response is a serializable resource' do
        let(:unsafe_body) { admin }
        specify { expect(subject.serialize_body).to eq(serialized_admin) }
      end
    end
  end

  describe '#permit_and_filter_response' do
    let(:admin) { build_stubbed(:user, :admin) }
    let(:moder) { build_stubbed(:user, :moder) }
    let(:serialized_admin) { admin.serializable_hash.deep_symbolize_keys }
    let(:serialized_moder) { moder.serializable_hash.deep_symbolize_keys }

    before do
      action.class_eval do
        safe_attributes :full_name, :gender
        permit_resource { |performer, item| item[:gender] == performer[:gender] }
      end
    end

    context 'response is a collection of serializable resources' do
      context 'performer is admin' do
        let(:performer) { admin }
        specify do
          expect(subject.permit_and_filter_response([serialized_admin, serialized_moder], action))
            .to match([{id: an_instance_of(Fixnum), full_name: 'Admin User', gender: true}])
        end

        specify do
          expect(subject.permit_and_filter_response([serialized_moder], action)).to eq([])
        end
      end

      context 'performer is moder' do
        let(:performer) { moder }
        specify do
          expect(subject.permit_and_filter_response([serialized_admin, serialized_moder], action))
            .to match([{id: an_instance_of(Fixnum), full_name: 'Moder User', gender: false}])
        end

        specify do
          expect(subject.permit_and_filter_response([serialized_admin], action)).to eq([])
        end
      end
    end

    context 'response is a serializable resource' do
      context 'performer is admin' do
        let(:performer) { admin }
        specify do
          expect(subject.permit_and_filter_response(serialized_admin, action))
            .to match({id: an_instance_of(Fixnum), full_name: 'Admin User', gender: true})
        end
      end

      context 'performer is moder' do
        let(:performer) { moder }
        specify do
          expect(subject.permit_and_filter_response(serialized_admin, action)).to eq(nil)
        end
      end
    end
  end

  describe '#permit_and_filter_included_response' do
    let(:query) { {included: [:notes]} }
    let(:admin) { {id: 1, full_name: 'Admin User', gender: true, notes: [
      {id: 1, title: 'Note 1', text: 'Note 1 text', user_id: 1},
      {id: 2, title: 'Note 2', text: 'Note 2 text', user_id: 2}
    ]} }
    let(:moder) { {id: 2, full_name: 'Moder User', gender: false, notes: [
      {id: 3, title: 'Note 3', text: 'Note 3 text', user_id: 1},
      {id: 4, title: 'Note 4', text: 'Note 4 text', user_id: 2}
    ]} }

    let(:action) do
      Class.new(AStream::BaseAction) do
        safe_attributes :full_name, :gender, :notes
        permit_resource true
      end
    end

    let(:notes_action) do
      Class.new(AStream::BaseAction) do
        safe_attributes :title, :user_id
        permit_resource { |performer, note| note[:user_id] == performer.id }
      end
    end

    before { allow(AStream).to receive(:find_class).and_return(notes_action) }

    context 'response is a collection of serializable resources' do
      context 'performer is admin' do
        let(:performer) { build_stubbed(:user, :admin, id: 1) }

        specify do
          expect(subject.permit_and_filter_included_response([admin, moder]))
            .to eq([
                    {id: 1, full_name: 'Admin User', gender: true, notes: [
                      {id: 1, title: 'Note 1', user_id: 1}
                    ]},
                    {id: 2, full_name: 'Moder User', gender: false, notes: [
                      {id: 3, title: 'Note 3', user_id: 1}
                    ]}
                  ])
        end
      end

      context 'performer is moder' do
        let(:performer) { build_stubbed(:user, :moder, id: 2) }

        specify do
          expect(subject.permit_and_filter_included_response([admin, moder]))
            .to eq([
                    {id: 1, full_name: 'Admin User', gender: true, notes: [
                      {id: 2, title: 'Note 2', user_id: 2}
                    ]},
                    {id: 2, full_name: 'Moder User', gender: false, notes: [
                      {id: 4, title: 'Note 4', user_id: 2}
                    ]}
                  ])
        end
      end
    end

    context 'response is a serializable resource' do
      context 'performer is admin' do
        let(:performer) { build_stubbed(:user, :admin, id: 1) }

        specify do
          expect(subject.permit_and_filter_included_response(admin))
            .to eq({id: 1, full_name: 'Admin User', gender: true, notes: [
                      {id: 1, title: 'Note 1', user_id: 1}
                    ]})
        end

        specify do
          expect(subject.permit_and_filter_included_response(moder))
            .to eq({id: 2, full_name: 'Moder User', gender: false, notes: [
                      {id: 3, title: 'Note 3', user_id: 1}
                    ]})
        end
      end

      context 'performer is moder' do
        let(:performer) { build_stubbed(:user, :moder, id: 2) }

        specify do
          expect(subject.permit_and_filter_included_response(admin))
            .to eq({id: 1, full_name: 'Admin User', gender: true, notes: [
                      {id: 2, title: 'Note 2', user_id: 2}
                    ]})
        end

        specify do
          expect(subject.permit_and_filter_included_response(moder))
            .to eq({id: 2, full_name: 'Moder User', gender: false, notes: [
                      {id: 4, title: 'Note 4', user_id: 2}
                    ]})
        end
      end
    end
  end
end
