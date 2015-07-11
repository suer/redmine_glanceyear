Redmine::Plugin.register :redmine_glanceyear do
  name 'Redmine glanceyear plugin'
  author 'suer'
  description 'This is a plugin for Redmine to draw year activities'
  version '0.0.1'
  url 'https://github.com/suer/redmine_glanceyear/'
  author_url 'https://d.hatena.ne.jp/suer/'

  project_module :glanceyear do
    permission :glanceyear, {:glanceyear => [:show]}, :public => true
    menu :project_menu, :glanceyear, {:controller => 'glanceyear', :action => 'show'},
    :caption => :menu_glanceyear, :param => :project_id
  end
end
