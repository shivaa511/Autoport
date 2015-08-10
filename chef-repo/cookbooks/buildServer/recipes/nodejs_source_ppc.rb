# Installs nodejs using source/build method on the archive maintained over autoport_repo.

version       = node['buildServer']['nodejs']['version']
install_dir   = node['buildServer']['nodejs']['install_dir']
nodejs_pkg    = "node-v#{version}-release-ppc"
archive_dir   = node['buildServer']['download_location']
repo_url      = node['buildServer']['repo_url']

remote_file "#{archive_dir}/#{nodejs_pkg}.tar.gz" do
  source "#{repo_url}/archives/#{nodejs_pkg}.tar.gz"
  owner 'root'
  group 'root'
  action :create
  mode '0644'
end

execute "Extracting nodejs #{version}" do
  cwd install_dir
  user 'root'
  group 'root'
  command "tar -xvf #{archive_dir}/#{nodejs_pkg}.tar.gz"
  creates "#{install_dir}/node"
end

execute "Building nodejs #{version}" do
  cwd "#{install_dir}/node"
  command './configure --dest-cpu=ppc64 && make && make install'
end

buildServer_log 'node-v' do
  name         'node-v'
  log_location node['log_location']
  log_record   "node-v,#{version},nodejs_source,nodejs"
  action       :add
end
