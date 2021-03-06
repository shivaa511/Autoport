# This recipe is used to install ant package , either via binary source or via package manager.
# It also sets ant_home using ant.sh in profile.d
# The pre-requiste to install ant is to configure java environment.
# By default node attribute 'source_install' is to false.
# Default behaviour is to install ant using package manager.
# If we need to install it via archive file , override 'source_install' attribute to 'true'

include_recipe 'buildServer::java'

src_install = node['buildServer']['apache-ant']['source_install']

if src_install == 'true'
  include_recipe 'buildServer::ant_binary'
else
  opt = ''
  opt = '--force-yes' if node['platform'] == 'ubuntu'

  ant_basedir = '/usr/share/ant'

  package 'ant' do
    action :upgrade
    options opt
    ignore_failure true
  end

  template '/etc/profile.d/ant.sh' do
    owner 'root'
    group 'root'
    source 'ant.sh.erb'
    mode '0644'
    variables(
      ant_home: ant_basedir
    )
    ignore_failure true
    only_if { Dir.exist?(ant_basedir) }
  end

  buildServer_log "apache-ant" do
    name         "apache-ant"
    log_location node['log_location']
    log_record   "apache-ant"
    action       :remove
    ignore_failure true
    only_if { Dir.exist?(ant_basedir) }
  end
end
