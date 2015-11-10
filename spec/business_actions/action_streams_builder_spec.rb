require 'rails_helper'

describe ActionStreamsBuilder do
  subject(:builder) { described_class }

  describe '.build' do
    let(:action_stream) { 'some stream' }
    before { allow(builder).to receive(:_parse).and_return([get: 'users#test']) }
    before { allow(builder).to receive(:_build).and_return([{}]) }

    specify do
      expect(builder).to receive(:_parse).with(action_stream).ordered
      expect(builder).to receive(:_build).with([get: 'users#test']).ordered
    end
    after { expect(builder.build(action_stream)).to eq([{}]) }
  end

  describe '._parse' do
    let(:expected_action_stream) { {get: 'users#search',
                           query: {active: true},
                           pipe: {'users#show' => ['users#approve', 'users#reject']}}.with_indifferent_access }

    context 'given valid data' do
      context 'given action stream is a json string' do
        let(:stream) { '{"get": "users#search",
                         "query": {"active": true},
                         "pipe": {"users#show": ["users#approve", "users#reject"]}}' }

        it 'returns an array of hash-like stream objects' do
          expect(builder._parse(stream)).to eq([expected_action_stream])
        end
      end

      context 'given action stream is a hash' do
        let(:stream) { {get: 'users#search',
                        query: {active: true},
                        pipe: {'users#show' => ['users#approve', 'users#reject']}} }

        it 'returns an array of hash-like stream objects' do
          expect(builder._parse(stream)).to eq([expected_action_stream])
        end
      end

      context 'given an array of streams' do
        let(:stream) { [{
                          get: 'users#search',
                          query: {active: true},
                          pipe: {'users#show' => ['users#approve', 'users#reject']}
                        },
                        '{"get": "users#search",
                          "query": {"active": true},
                          "pipe": {"users#show": ["users#approve", "users#reject"]}}'
                        ] }

        it 'returns an array of hash-like stream objects' do
          expect(builder._parse(stream)).to eq([expected_action_stream, expected_action_stream])
        end
      end
    end

    context 'given invalid data' do
      context 'given invalid JSON' do
        let(:stream) { '{"get": "users#search",
                              "query": {"active": true},
                              "pipe": {"users#show": ["users#approve", "users#reject"' }

        specify { expect { builder._parse(stream) }.to raise_error(ActionRunner::StreamParseError,
                                                                  /Can't parse provided action tree JSON/) }
      end

      context 'given invalid data type' do
        let(:stream) { false }

        specify { expect { builder._parse(stream) }.to raise_error(ActionRunner::StreamParseError,
                                                                  /Action tree should be either a hash, an array, or a valid JSON string/) }
      end
    end
  end

  describe '._build' do
    before do
      module Actions
        module Test
          class Action1
            def self.query_attributes
              []
            end
          end
        end
      end
      module Actions
        module Test
          class Action2
            def self.query_attributes
              []
            end
          end
        end
      end
    end

    context 'given array of streams' do
      let(:streams) { [{post: 'test#action_1', query: {}},
                       {get: 'test#action_2', query: {}}] }

      it 'creates an array of action requests' do
        expect(builder._build(streams)).to eq([
          ActionRequest.new(runner: Actions::Test::Action1, type: :post, query: {}),
          ActionRequest.new(runner: Actions::Test::Action2, query: {})
        ])
      end
    end

    context 'given one stream' do
      let(:streams) { [post: 'test#action_1', query: {}] }
      specify do
        expect(builder._build(streams)).to eq([
          ActionRequest.new(runner: Actions::Test::Action1, type: :post, query: {})
        ])
      end
    end

    context 'given one stream with one piped stream' do
      let(:streams) { [get: 'test#action_1', pipe: 'test#action_1'] }
      specify do
        expect(builder._build(streams)).to eq([
          ActionRequest.new(runner: Actions::Test::Action1, pipe:
            ActionRequest.new(runner: Actions::Test::Action1))
        ])
      end
    end

    context 'given one stream with piped stream and one more piped stream' do
      let(:streams) { [get: 'test#action_1', pipe: {'test#action_1' => 'test#action_1'}] }
      specify do
        expect(builder._build(streams)).to eq([
          ActionRequest.new(runner: Actions::Test::Action1, pipe:
            ActionRequest.new(runner: Actions::Test::Action1, pipe:
              ActionRequest.new(runner: Actions::Test::Action1)))
        ])
      end
    end

    context 'given one stream with two piped streams' do
      let(:streams) { [get: 'test#action_1', pipe: ['test#action_1', 'test#action_1']] }
      specify do
        expect(builder._build(streams)).to eq([
          ActionRequest.new(runner: Actions::Test::Action1, pipe: [
            ActionRequest.new(runner: Actions::Test::Action1),
            ActionRequest.new(runner: Actions::Test::Action1)])
        ])
      end
    end

    context 'given one stream with piped stream and two more piped streams' do
      let(:streams) { [get: 'test#action_1', pipe: {'test#action1' => ['test#action_1', 'test#action_1']}] }
      specify do
        expect(builder._build(streams)).to eq([
          ActionRequest.new(runner: Actions::Test::Action1, pipe:
            ActionRequest.new(runner: Actions::Test::Action1, pipe: [
              ActionRequest.new(runner: Actions::Test::Action1),
              ActionRequest.new(runner: Actions::Test::Action1)]))
        ])
      end
    end

    context 'given one stream with piped stream and one more piped stream and one more piped stream' do
      let(:streams) { [get: 'test#action_1', pipe: {'test#action1' => {'test#action_1' => 'test#action_1'}}] }
      specify do
        expect(builder._build(streams)).to eq([
          ActionRequest.new(runner: Actions::Test::Action1, pipe:
            ActionRequest.new(runner: Actions::Test::Action1, pipe:
              ActionRequest.new(runner: Actions::Test::Action1, pipe:
                ActionRequest.new(runner: Actions::Test::Action1))))
        ])
      end
    end
  end
end
