Redmine::Plugin.register :redmine_enhanced_view do
  name 'Redmine enhanced View plugin'
  author 'Onur Kucuk'
  description 'Redmine plugin to display tree view of some components'
  version '0.5'
  url 'http://www.ozguryazilim.com.tr'
  author_url 'http://www.ozguryazilim.com.tr'
  requires_redmine :version_or_higher => '3.0.0'

  permission :view_project_members, {:projects => [:show]}, :require => :member
end

