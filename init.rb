require 'redmine_enhanced_view'

Redmine::Plugin.register :redmine_enhanced_view do
  name 'Redmine enhanced View plugin'
  author 'Onur Kucuk'
  description 'Redmine plugin to display tree view of some components'
  version '0.7'
  url 'http://www.ozguryazilim.com.tr'
  author_url 'http://www.ozguryazilim.com.tr'
  requires_redmine :version_or_higher => '3.0.0'

  permission :view_project_members, {:projects => [:show]}, :require => :member
  permission :issue_assign_users, {:issues => [:edit]}, :require => :member
end

Rails.configuration.to_prepare do
  [
    [Project, RedmineEnhancedView::Patches::ProjectPatch],
    [Issue, RedmineEnhancedView::Patches::IssuePatch]
  ].each do |classname, modulename|
    unless classname.included_modules.include?(modulename)
      classname.send(:include, modulename)
    end
  end

end

