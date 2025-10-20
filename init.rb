require 'redmine'

require_dependency File.dirname(__FILE__) + '/lib/redmine_extended_issue_relations/auto_completes_controller_patch'

Redmine::Plugin.register :redmine_extended_issue_relations do
  name 'Redmine Extended Issue Relations'
  author 'Christophe Hartmann'
  description 'Affiche et recherche les projets dans l’autocomplete des demandes liées'
  version '0.2.4'
  url 'https://github.com/tititoof/redmine_extended_issue_relations'
  author_url 'https://github.com/tititoof'

  requires_redmine version_or_higher: '6.0'
end
