# -*- mode: ruby; coding: utf-8 -*-

$: << File.expand_path('../../work/war/', __FILE__)
$: << File.expand_path('../../work/war/WEB-INF/lib/', __FILE__)

require 'winstone.jar'
require 'commons-logging-1.1.1.jar'
require 'commons-httpclient-3.1.jar'
jenkins_core = Dir[File.expand_path('../../work/war/WEB-INF/lib/jenkins-core-*.jar', __FILE__)].max_by { |_| File.basename(_) }
require jenkins_core

require 'hipchat/publisher'

