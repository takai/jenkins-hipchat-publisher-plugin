# -*- mode:ruby; coding: utf-8 -*-

Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = "jenkins-hipchat-publisher"
  plugin.display_name = "Jenkins Hipchat Publisher Plugin"
  plugin.version = '0.0.1'
  plugin.description = 'This plugin enables Jenkins to send build notifications to HipChat.'

  # plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/Jenkins+Hipchat+Publisher+Plugin'

  # The first argument is your user name for jenkins-ci.org.
  plugin.developed_by "takai", "Naoto Takai <takai@recompile.net>"

  plugin.uses_repository :github => "takai/jenkins-hipchat-publisher-plugin"

  plugin.depends_on 'ruby-runtime', '0.10'
end
