include_recipe 'hadoop::hadoop_yarn_resourcemanager'
include_recipe 'hadoop::hadoop_yarn_nodemanager'

include_recipe 'hadoop_test::systemd_reload'

ruby_block 'Start YARN' do
  block do
    true
  end
  notifies :run, 'execute[systemd-daemon-reload]', :immediately if
    (node['platform_family'] == 'rhel' && node['platform_version'].to_i >= 7) ||
    (node['platform'] == 'ubuntu' && node['platform_version'].to_i >= 16) ||
    (node['platform'] == 'debian' && node['platform_version'].to_i >= 8)
  notifies :start, 'service[hadoop-yarn-resourcemanager]', :immediately
  notifies :start, 'service[hadoop-yarn-nodemanager]', :immediately
end
