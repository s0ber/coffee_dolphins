shared_examples_for 'action classes definition' do
  before do
    module Actions
      module Test
        %w(Action1 Action2 Action3 Action4 Action5).each do |a|
          const_set(a, Class.new(AStream::BaseAction) {
            query_by('test#action1') { |response| {}}
            query_by('test#action2') { |response| {}}
            query_by('test#action3') { |response| {}}
            query_by('test#action4') { |response| {}}
            query_by('test#action5') { |response| {}}

            def self.query_attributes
              []
            end
          })
        end

        class CantPipeAction < AStream::BaseAction
          def self.query_attributes
            []
          end
        end

        class Test < AStream::BaseAction
          def self.query_attributes
            [:test]
          end
        end
      end

      module Users
        class Show < AStream::BaseAction
          def self.query_attributes
          end

          def self.permit(performer, user)
            performer && (performer[:admin] == true || user[:name] == performer[:name])
          end
        end
      end

      module Users
        class ShowWithNotes < AStream::BaseAction
          def self.query_attributes
          end

          def self.include
            [:notes]
          end

          def self.permit(performer, user)
          end
        end
      end

      module Notes
        class Show < AStream::BaseAction
          def self.query_attributes
          end

          def self.permit(performer, user)
          end
        end
      end
    end

    module Test
      class ActionFromWrongNamespace < AStream::BaseAction
      end
    end
  end

  after do
    %w(Action1 Action2 Action3 Action4 Action5 Test CantPipeAction).each do |a|
      Actions::Test.send :remove_const, a.to_sym
    end

    %w(Show ShowWithNotes).each do |a|
      Actions::Users.send :remove_const, a.to_sym
    end
    Test.send :remove_const, :ActionFromWrongNamespace
  end
end
