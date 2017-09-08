#

describe directory('/etc/hadoop/conf.chef') do
  it { should exist }
  it { should be_readable }
end

%w(
  core-site.xml
  hdfs-site.xml
  mapred-site.xml
  yarn-site.xml
).each do |sitefile|
  describe file("/etc/hadoop/conf.chef/#{sitefile}") do
    it { should exist }
  end
end

%w(
  hadoop-hdfs-namenode
  hadoop-hdfs-datanode
  hadoop-yarn-resourcemanager
  hadoop-yarn-nodemanager
).each do |svc|
  describe service(svc) do
    it { should be_installed }
    it { should be_running }
  end
end

# These listen on all interfaces
%w(
  50070
  50010
  50020
  50075
).each do |prt|
  describe port(prt) do
    it { should be_listening }
    its('processes') { should include 'java' }
    its('protocols') { should include 'tcp' }
    its('addresses') { should include '0.0.0.0' }
  end
end

# These listen on the primary interface only, which we cannot easily predict
%w(
  8020
  8030
  8031
  8032
  8033
  8088
).each do |prt|
  describe port(prt) do
    it { should be_listening }
    its('processes') { should include 'java' }
    its('protocols') { should include 'tcp' }
  end
end

[
  'hdfs dfs -ls /',
  'yarn application -list',
].each do |cmd|
  describe command(cmd) do
    its('exit_status') { should eq 0 }
  end
end
