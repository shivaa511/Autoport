version       = node['buildServer']['ibm-java-sdk']['version']
arch          = node['kernel']['machine']
java_package  = "ibm-java-sdk-#{version}"
install_dir   = node['buildServer']['ibm-java-sdk']['install_dir']
repo_url      = node['buildServer']['repo_url']
arch          = node['kernel']['machine']

directory "Creating install directory for ibm-java" do
  path   install_dir
  action :create
  owner 'root'
  group 'root'
  mode  '0755'
  ignore_failure true
end

remote_file "#{install_dir}/#{java_package}-#{arch}-archive.bin" do
  source "#{repo_url}/archives/#{java_package}-#{arch}-archive.bin"
  owner 'root'
  group 'root'
  action :create
  mode '0777'
  ignore_failure true
end

template "#{install_dir}/ibm-java-installer.properties" do
  source "ibm-java-installer.properties.erb"
  owner 'root'
  group 'root'
  action :create
  mode '0644'
  variables(
    install_dir:"#{install_dir}/#{java_package}"
  )
  ignore_failure true
  only_if { File.exist?("#{install_dir}/#{java_package}-#{arch}-archive.bin") }
end

execute "Executing Java Binary" do
  cwd     install_dir
  command "./#{java_package}-#{arch}-archive.bin \
    -f ./ibm-java-installer.properties -i silent 1>ibm-java-log 2>&1"
  environment(
     '_JAVA_OPTIONS' => '-Dlax.debug.level=3 -Dlax.debug.all=true',
     'LAX_DEBUG' => '1'
  )
  creates "#{install_dir}/#{java_package}"
  ignore_failure true
  only_if { File.exist?("#{install_dir}/#{java_package}-#{arch}-archive.bin") }
end

template '/etc/profile.d/ibm-java.sh' do
  owner 'root'
  group 'root'
  source 'ibm-java.sh.erb'
  mode '0644'
  variables(
    java_home:"#{install_dir}/#{java_package}"
  )
  ignore_failure true
  only_if { Dir.exist?("#{install_dir}/#{java_package}") }
end

record = "ibm-java-sdk,#{version},ibm-java-sdk,ibm-java-sdk,#{arch},.bin,#{java_package}-#{arch}-archive.bin"

buildServer_log 'ibm-java-sdk' do
  name         'ibm-java-sdk'
  log_location node['log_location']
  log_record   record
  action       :add
  ignore_failure true
  only_if { Dir.exist?("#{install_dir}/#{java_package}") }
end
