shared_examples_for 'action classes definition' do
  after do
    %w(Action1 Action2 Action3 Action4 Action5 Test CantPipeAction).each do |a|
      Actions::Test.send :remove_const, a.to_sym
    end

    %w(Show ShowWithNotes).each do |a|
      Actions::Users.send :remove_const, a.to_sym
    end

    Test.send :remove_const, :ActionFromWrongNamespace
  end

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

            query_params :name
          })
        end

        class CantPipeAction < AStream::BaseAction
          query_params :name
        end

        class Test < AStream::BaseAction
          query_params :test
        end
      end

      module Users
        class Show < AStream::BaseAction
          query_params :test
          permit_resource { |performer, user| performer && (performer[:admin] == true || user[:name] == performer[:name]) }
        end
      end

      module Users
        class ShowWithNotes < AStream::BaseAction
          query_params :test
          included_resources :notes
          permit_resource true
        end
      end

      module Notes
        class Show < AStream::BaseAction
          query_params :test
          permit_resource true
        end
      end
    end

    module Test
      class ActionFromWrongNamespace < AStream::BaseAction
      end
    end
  end
end
