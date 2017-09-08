require 'spec_helper'

describe 'hadoop::hadoop_mapreduce_historyserver' do
  context 'on CentOS 6.9' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.9) do |node|
        node.automatic['domain'] = 'example.com'
        stub_command(/update-alternatives --display /).and_return(false)
        stub_command(/test -L /).and_return(false)
      end.converge(described_recipe)
    end
    pkg = 'hadoop-mapreduce-historyserver'

    %W(
      /etc/default/#{pkg}
      /etc/init.d/#{pkg}
    ).each do |file|
      it "creates #{file} from template" do
        expect(chef_run).to create_template(file)
      end
    end

    it "creates #{pkg} service resource, but does not run it" do
      expect(chef_run).to_not disable_service(pkg)
      expect(chef_run).to_not enable_service(pkg)
      expect(chef_run).to_not reload_service(pkg)
      expect(chef_run).to_not restart_service(pkg)
      expect(chef_run).to_not start_service(pkg)
      expect(chef_run).to_not stop_service(pkg)
    end

    it 'creates mapreduce-jobhistory-intermediate-done-dir execute resource, but does not run it' do
      expect(chef_run).to_not run_execute('mapreduce-jobhistory-intermediate-done-dir').with(user: 'hdfs')
    end

    it 'creates mapreduce-jobhistory-done-dir execute resource, but does not run it' do
      expect(chef_run).to_not run_execute('mapreduce-jobhistory-done-dir').with(user: 'hdfs')
    end
  end
end
