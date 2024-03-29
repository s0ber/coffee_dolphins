require 'rails_helper'

describe AStream do
  subject(:runner) { described_class }

  describe '.run' do
    let(:performer) { create(:user, :admin) }
    let(:controller) { double('fake controller') }
    let(:action_streams) { double('action streams') }
    let(:streams_builder) { double('ActionStreamsBuilder') }
    let(:streams_runner) { double('ActionStreamsRunner') }
    let(:normalized_action_streams) { double('normalized action streams') }

    context 'controller is specified' do
      specify do
        expect(AStream::ActionStreamsBuilder).to receive(:new).with(performer: performer).and_return(streams_builder)
        expect(streams_builder).to receive(:build).with(action_streams).and_return(normalized_action_streams)
        expect(AStream::ActionStreamsRunner).to receive(:new).with(performer: performer, controller: controller).and_return(streams_runner)
        expect(streams_runner).to receive(:run).with(normalized_action_streams)
      end

      after do
        AStream.run(performer, action_streams, controller)
      end
    end

    context 'controller is not specified' do
      specify do
        expect { AStream.run(performer, action_streams) }.to raise_error ArgumentError
      end
    end
  end

  describe '.find_class' do
    let(:action_string) { '' }
    before do
      module TestNamespace; class TestAction; end; end
    end

    context 'namespace and action are specified' do
      let(:action_string) { 'test_namespace#test_action' }
      specify do
        expect(runner.find_class(action_string)).to eq(TestNamespace::TestAction)
      end
    end

    context 'namespace is not specified' do
      let(:action_string) { '#test_action' }
      specify do
        expect { runner.find_class(action_string) }.to raise_error(AStream::ActionNotFound,
                                                                   /Action namespace is not specified/)
      end
    end

    context 'action in not specified' do
      let(:action_string) { 'test-namespace#' }
      specify { expect { runner.find_class('test-namespace#') }.to raise_error(AStream::ActionNotFound,
                                                                               /Action name is not specified/) }
    end

    context 'action which does not exist is specified' do
      specify { expect { runner.find_class('TestNamespace#Asd') }.to raise_error(AStream::ActionNotFound,
                                                                                 /Can't find action TestNamespace#Asd/) }
    end
  end
end
