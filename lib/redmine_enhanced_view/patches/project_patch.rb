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

        def assignable_users_with_redmine_enhanced_view
          if User.current.allowed_to?(:issue_assign_users, self)
            assignable_users_without_redmine_enhanced_view
          else
            types = []
            types << 'Group' if Setting.issue_group_assignment?

            @assignable_users ||= Principal.
              active.
              joins(:members => :roles).
              where(:type => types, :members => {:project_id => id}, :roles => {:assignable => true}).
              uniq.
              sorted
          end
        end

      end

    end
  end
end

