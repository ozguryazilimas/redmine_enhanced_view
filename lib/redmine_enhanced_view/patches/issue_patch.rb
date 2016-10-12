require_dependency 'issue'

module RedmineEnhancedView
  module Patches
    module IssuePatch
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
          users = assignable_users_without_redmine_enhanced_view
          users.select!{|k| k.is_a?(Group)} unless User.current.allowed_to?(:issue_assign_users, project)
          users
        end

      end

    end
  end
end

