# This recipe installs ant via tarball hosted over the autoport repository.
# Pre-requiste is to install java.
# This recipe also sets ant_home and sets default path variable for ant.

include_recipe 'buildServer::java'

version       = node['buildServer']['ant']['version']
install_dir   = node['buildServer']['ant']['install_dir']
ant_pkg       = "apache-ant-#{version}"
archive_dir   = node['buildServer']['ant']['download_location']
ant_home      = "#{install_dir}/#{ant_pkg}"
repo_url      = node['buildServer']['repo_url']

remote_file "#{archive_dir}/#{ant_pkg}-bin.tar.bz2" do
  source "#{repo_url}/archives/#{ant_pkg}-bin.tar.bz2"
  owner 'root'
  group 'root'
  action :create
  mode '0644'
end

execute "Extracting ant #{version}" do
  cwd install_dir
  user 'root'
  group 'root'
  command "tar -jxf #{archive_dir}/#{ant_pkg}-bin.tar.bz2"
  creates "#{install_dir}/#{ant_pkg}"
end

template '/etc/profile.d/ant.sh' do
  owner 'root'
  group 'root'
  source 'ant_source.sh.erb'
  mode '0644'
  variables(
    ant_home: ant_home
  )
end