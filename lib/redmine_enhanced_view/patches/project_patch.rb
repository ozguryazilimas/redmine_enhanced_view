require_dependency 'project'

module RedmineEnhancedView
  module Patches
    module ProjectPatch
      def self.included(base)
        # base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          alias_method_chain :assignable_users, :redmine_enhanced_view
        end
      end

      module InstanceMethods

        def assignable_users_with_redmine_enhanced_view(tracker = nil)
          if User.current.allowed_to?(:issue_assign_users, self)
            assignable_users_without_redmine_enhanced_view(tracker)
          else

            # types = ['User']
            types = []
            types << 'Group' if Setting.issue_group_assignment?

            scope = Principal.
              active.
              joins(:members => :roles).
              where(:type => types, :members => {:project_id => id}, :roles => {:assignable => true}).
              distinct.
              sorted

            if tracker
              # Rejects users that cannot the view the tracker
              roles = Role.where(:assignable => true).select {|role| role.permissions_tracker?(:view_issues, tracker)}
              scope = scope.where(:roles => {:id => roles.map(&:id)})
            end

            @assignable_users ||= {}
            @assignable_users[tracker] = scope
          end
        end

      end

    end
  end
end

