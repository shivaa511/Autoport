# This recipe is used to install nodejs package , either via source or via package manager.
# Over ppc64le architecture (rhel/ubuntu) source/build install is used.
# Over x86_64 (rhel/ubuntu) if source_install is true source/build install is used.
# Over x86_64 (rhel/ubuntu) if source_install is not true installation takes place via shell script,
# which manupilates the source-lists of package manager based on arch and distro and then package
# is installed via package manager using package resource of chef.

arch = node['kernel']['machine']
source_install = node['buildServer']['nodejs']['source_install']
if arch == 'ppc64le'
  include_recipe 'buildServer::nodejs_source_ppc'
else
  setup_file = ''
  case node[:platform]
  when 'ubuntu'
    setup_file = 'setup_deb'
    opt = '--force-yes'
  when 'redhat'
    setup_file = 'setup_rpm'
    opt = ''
  end

  cookbook_file "#{Chef::Config[:file_cache_path]}/#{setup_file}" do
    source setup_file
    owner 'root'
    group 'root'
    mode '777'
    action :create
  end

  bash "Execute setup script #{setup_file}" do
    cwd "#{Chef::Config[:file_cache_path]}"
    code <<-EOH
    ./#{setup_file} > #{Chef::Config[:file_cache_path]}/node_js_install_log
    EOH
  end

  package 'nodejs' do
    action :upgrade
    options opt
  end
end
