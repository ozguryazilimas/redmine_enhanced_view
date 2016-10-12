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
          without_rev = assignable_users_without_redmine_enhanced_view

          @assignable_users = if User.current.allowed_to?(:issue_assign_users, self)
                                without_rev
                              else
                                without_rev.to_a.select{|k| k.is_a?(Group)}
                              end
        end

      end

    end
  end
end

