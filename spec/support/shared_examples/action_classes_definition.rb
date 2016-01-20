shared_examples_for 'action classes definition' do
  after do
    %w(Action1 Action2 Action3 Action4 Action5 Test CantPipeAction WrongAction).each do |a|
      Test.send :remove_const, a.to_sym
    end

    %w(Show ShowWithNotes).each do |a|
      Users.send :remove_const, a.to_sym
    end
  end

  before do
    module Test
      %w(Action1 Action2 Action3 Action4 Action5).each do |a|
        const_set(a, Class.new(AStream::BaseAction) {
          query_by('test#action1') { |response| {}}
          query_by('test#action2') { |response| {}}
          query_by('test#action3') { |response| {}}
          query_by('test#action4') { |response| {}}
          query_by('test#action5') { |response| {}}
        })
      end

      class CantPipeAction < AStream::BaseAction
      end

      class Test < AStream::BaseAction
      end

      class WrongAction
      end
    end

    module Users
      class Show < AStream::BaseAction
        permit_resource { |performer, user| performer && (performer[:admin] == true || user[:name] == performer[:name]) }
      end

      class ShowWithNotes < AStream::BaseAction
        included_resources :notes
        permit_resource true
      end
    end

    module Notes
      class Show < AStream::BaseAction
        permit_resource true
      end
    end
  end
end
