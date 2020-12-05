require_dependency 'issue'

module RedmineEnhancedView
  module Patches
    module IssuePatch

      def assignable_users
        users = super
        users.select!{|k| k.is_a?(Group)} unless User.current.allowed_to?(:issue_assign_users, project)
        users
      end

    end
  end
end

Issue.prepend(RedmineEnhancedView::Patches::IssuePatch)

