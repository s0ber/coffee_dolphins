require 'rails_helper'

describe Actions::Base do
  describe 'action interface for child classes' do
    let(:test_child_class) { Class.new(described_class) }
    subject { test_child_class }

    specify do
      expect { subject.permit }.to raise_error(NotImplementedError)
    end

    specify do
      expect { subject.new.perform }.to raise_error(NotImplementedError)
    end
  end
end
