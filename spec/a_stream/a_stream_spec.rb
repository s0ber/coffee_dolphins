require 'rails_helper'

describe AStream do
  subject(:runner) { described_class }

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
