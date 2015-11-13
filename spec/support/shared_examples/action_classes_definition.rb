shared_examples_for 'action classes definition' do
  before do
    module Actions
      module Test
        %w(Action1 Action2 Action3 Action4 Action5 Action6 Action7).each do |a|
          const_set(a, Class.new {
            def self.query_attributes
              []
            end
          })
        end

        class Test
          def self.query_attributes
            [:test]
          end
        end
      end

      module Users
        class Show
          def self.query_attributes
          end

          def self.permit(performer, user)
            performer && (performer[:admin] == true || user[:name] == performer[:name])
          end
        end
      end

      module Users
        class ShowWithNotes
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
        class Show
          def self.query_attributes
          end

          def self.permit(performer, user)
          end
        end
      end
    end

    module Test
      class ActionFromWrongNamespace
      end
    end
  end

  after do
    %w(Action1 Action2 Action3 Action4 Action5 Action6 Action7 Test).each do |a|
      Actions::Test.send :remove_const, a.to_sym
    end

    %w(Show ShowWithNotes).each do |a|
      Actions::Users.send :remove_const, a.to_sym
    end
    Test.send :remove_const, :ActionFromWrongNamespace
  end
end
