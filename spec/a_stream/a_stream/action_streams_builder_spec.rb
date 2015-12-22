require 'rails_helper'
require 'support/shared_examples/action_classes_definition'

describe AStream::ActionStreamsBuilder do
  subject(:builder) { described_class.new(performer: user) }
  let(:user) { build_stubbed(:user) }

  describe '#build' do
    let(:action_stream) { 'some stream' }
    before { allow(builder).to receive(:_build) }

    specify do
      expect(builder).to receive(:_parse).with(action_stream).and_return([get: 'users#test']).ordered
      expect(builder).to receive(:_build).with([get: 'users#test']).and_return([{}]).ordered
    end

    after { expect(builder.build(action_stream)).to eq([{}]) }
  end

  describe '#_parse' do
    let(:expected_action_stream) { {get: 'users#search',
                           query: {active: true},
                           pipe: {:'users#show' => ['users#approve', 'users#reject']}} }

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

        specify { expect { builder._parse(stream) }
          .to raise_error(AStream::StreamParseError, /Can't parse provided action tree JSON/) }
      end

      context 'given invalid data type' do
        let(:stream) { false }

        specify { expect { builder._parse(stream) }
          .to raise_error(AStream::StreamParseError, /Action tree should be either a hash, an array, or a valid JSON string/) }
      end
    end
  end

  describe '#_build' do
    include_examples 'action classes definition'

    context 'given array of streams' do
      let(:streams) { [{post: 'test#action_1', query: {}},
                       {get: 'test#action_2', query: {}}] }

      it 'creates an array of action requests' do
        expect(builder._build(streams)).to eq([
          AStream::ActionRequest.new(runner: Test::Action1, performer: user, type: :post, query: {}),
          AStream::ActionRequest.new(runner: Test::Action2, performer: user, query: {})
        ])
      end
    end

    context 'given one stream' do
      let(:streams) { [post: 'test#action_1', query: {}] }
      specify do
        expect(builder._build(streams)).to eq([
          AStream::ActionRequest.new(runner: Test::Action1, performer: user, type: :post, query: {})
        ])
      end
    end

    context 'given one stream with one piped stream' do
      context 'actions can be piped' do
        let(:streams) { [get: 'test#action_1', pipe: 'test#action_2'] }

        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe:
              AStream::ActionRequest.new(runner: Test::Action2, performer: user))
          ])
        end
      end

      context 'actions cant be piped' do
        let(:streams) { [get: 'test#action_1', pipe: 'test#cant_pipe_action'] }

        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user)
          ])
        end
      end
    end

    context 'given one stream with piped stream and one more piped stream' do
      context 'actions can be piped' do
        let(:streams) { [get: 'test#action_1', pipe: {'test#action_1' => 'test#action_2'}] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe:
              AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe:
                AStream::ActionRequest.new(runner: Test::Action2, performer: user)))
          ])
        end
      end

      context 'first action cannot be piped' do
        let(:streams) { [get: 'test#action_1', pipe: {'test#cant_pipe_action' => 'test#action_2'}] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user)
          ])
        end
      end

      context 'second action cannot be piped' do
        let(:streams) { [get: 'test#action_1', pipe: {'test#action_1' => 'test#cant_pipe_action'}] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe:
              AStream::ActionRequest.new(runner: Test::Action1, performer: user))
          ])
        end
      end
    end

    context 'given one stream with two piped streams' do
      context 'action can be piped' do
        let(:streams) { [get: 'test#action_1', pipe: ['test#action_2', 'test#action_3']] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe: [
              AStream::ActionRequest.new(runner: Test::Action2, performer: user),
              AStream::ActionRequest.new(runner: Test::Action3, performer: user)])
          ])
        end
      end

      context 'first action cannot be piped' do
        let(:streams) { [get: 'test#action_1', pipe: ['test#cant_pipe_action', 'test#action_3']] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe: [
              AStream::ActionRequest.new(runner: Test::Action3, performer: user)])
          ])
        end
      end

      context 'second action cannot be piped' do
        let(:streams) { [get: 'test#action_1', pipe: ['test#action_2', 'test#cant_pipe_action']] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe: [
              AStream::ActionRequest.new(runner: Test::Action2, performer: user)])
          ])
        end
      end
    end

    context 'given one stream with piped stream and two more piped streams' do
      context 'actions can be piped' do
        let(:streams) { [get: 'test#action_1', pipe: {'test#action2' => ['test#action_3', 'test#action_4']}] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe:
              AStream::ActionRequest.new(runner: Test::Action2, performer: user, pipe: [
                AStream::ActionRequest.new(runner: Test::Action3, performer: user),
                AStream::ActionRequest.new(runner: Test::Action4, performer: user)]))
          ])
        end
      end

      context 'cant pipe first action' do
        let(:streams) { [get: 'test#action_1', pipe: {'test#cant_pipe_action' => ['test#action_3', 'test#action_4']}] }
        specify do
          expect(builder._build(streams)).to eq([AStream::ActionRequest.new(runner: Test::Action1, performer: user)])
        end
      end

      context 'cant pipe second action' do
        let(:streams) { [get: 'test#action_1', pipe: {'test#action2' => ['test#cant_pipe_action', 'test#action_4']}] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe:
              AStream::ActionRequest.new(runner: Test::Action2, performer: user, pipe: [
                AStream::ActionRequest.new(runner: Test::Action4, performer: user)]))
          ])
        end
      end
    end

    context 'given one stream with piped stream and one more piped stream and one more piped stream' do
      context 'actions can be piped' do
        let(:streams) { [get: 'test#action_1', pipe: {'test#action2' => {'test#action_3' => 'test#action_4'}}] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe:
              AStream::ActionRequest.new(runner: Test::Action2, performer: user, pipe:
                AStream::ActionRequest.new(runner: Test::Action3, performer: user, pipe:
                  AStream::ActionRequest.new(runner: Test::Action4, performer: user))))
          ])
        end
      end

      context 'third action cannot be piped' do
        let(:streams) { [get: 'test#action_1', pipe: {'test#action2' => {'test#cant_pipe_action' => 'test#action_4'}}] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe:
              AStream::ActionRequest.new(runner: Test::Action2, performer: user))
          ])
        end
      end

      context 'forth action cannot be piped' do
        let(:streams) { [get: 'test#action_1', pipe: {'test#action2' => {'test#action_3' => 'test#cant_pipe_action'}}] }
        specify do
          expect(builder._build(streams)).to eq([
            AStream::ActionRequest.new(runner: Test::Action1, performer: user, pipe:
              AStream::ActionRequest.new(runner: Test::Action2, performer: user, pipe:
                AStream::ActionRequest.new(runner: Test::Action3, performer: user)))
          ])
        end
      end
    end
  end
end
