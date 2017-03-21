require 'spec_helper'

describe 'sshd_server_version' do
  before do
    Facter.clear
    Facter::Util::Resolution.stubs(:exec)
    Facter.fact(:kernel).stubs(:value).returns('linux')
  end
  context 'on a Linux host' do
    context 'with 7.2p2' do
      before do
        openssh_version_string_7_2 = <<-EOS
unknown option -- V
OpenSSH_7.2p2 Ubuntu-4ubuntu2.1, OpenSSL 1.0.2g  1 Mar 2016
usage: sshd [-46DdeiqTt] [-b bits] [-C connection_spec] [-c host_cert_file]
            [-E log_file] [-f config_file] [-g login_grace_time]
            [-h host_key_file] [-k key_gen_time] [-o option] [-p port]
            [-u len]
EOS
        Facter::Util::Resolution.expects(:which).with('sshd').returns('/usr/bin/sshd')
        Facter::Util::Resolution.expects(:exec).with('sshd -V 2>&1').returns(openssh_version_string_7_2)
      end
      it 'execs ssh -V and returns full version number (7.2p2)' do
        expect(Facter.fact(:sshd_server_version).value).to eq('7.2p2')
      end
    end
    context 'with 6.6.1p1' do
      before do
        openssh_version_string_6_6_1 = <<-EOS
unknown option -- V
OpenSSH_6.6.1p1, OpenSSL 1.0.1e-fips 11 Feb 2013
usage: sshd [-46DdeiqTt] [-b bits] [-C connection_spec] [-c host_cert_file]
            [-E log_file] [-f config_file] [-g login_grace_time]
            [-h host_key_file] [-k key_gen_time] [-o option] [-p port]
            [-u len]
EOS
        Facter::Util::Resolution.expects(:which).with('sshd').returns('/usr/bin/sshd')
        Facter::Util::Resolution.expects(:exec).with('sshd -V 2>&1').returns(openssh_version_string_6_6_1)
      end
      it 'execs ssh -V and returns full version number (6.6.1p1)' do
        expect(Facter.fact(:sshd_server_version).value).to eq('6.6.1p1')
      end
    end
    context 'with 5.3p1' do
      before do
        openssh_version_string_5_3 = <<-EOS
sshd: illegal option -- V
OpenSSH_5.3p1, OpenSSL 1.0.1e-fips 11 Feb 2013
usage: sshd [-46DdeiqTt] [-b bits] [-C connection_spec] [-c host_cert_file]
            [-f config_file] [-g login_grace_time] [-h host_key_file]
            [-k key_gen_time] [-o option] [-p port] [-u len]
EOS
        Facter::Util::Resolution.expects(:which).with('sshd').returns('/usr/bin/sshd')
        Facter::Util::Resolution.expects(:exec).with('sshd -V 2>&1').returns(openssh_version_string_5_3)
      end
      it 'execs ssh -V and returns full version number (5.3p1)' do
        expect(Facter.fact(:sshd_server_version).value).to eq('5.3p1')
      end
    end
    context 'with no installation' do
      before do
        Facter::Util::Resolution.expects(:which).with('sshd').returns(nil)
      end
      it 'does not exec ssh and returns nil' do
        expect(Facter.fact(:sshd_server_version).value).to eq(nil)
      end
    end
  end
end
