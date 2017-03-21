require 'spec_helper_acceptance'

describe 'mozilla_ssh_hardening::server class' do
  context 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
      class{'mozilla_ssh_hardening::server':
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it 'should return a fact' do
      pp = <<-EOS
      notify{"SSHD Version: ${::sshd_server_version}":}
      EOS

      # Check output for fact string
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/SSHD Version: [\d.]{2,}[p][\d].*$/)
      end
    end
  end
end

describe 'ssh should pass ssh_scan mozilla test' do
  it 'install sqlite for ssh_scan' do
    sqlite_pp = <<-EOS
    case $::osfamily {
      'RedHat': {
        $sqlite_devel = 'sqlite-devel'
      }
      'Debian': {
        $sqlite_devel = 'libsqlite3-dev'
      }
      default: {
        fail("Test doesnt support ${::osfamily} yet")
      }
    }


    package {'sqlite':
      ensure => present,
    }
    ->
    package {$sqlite_devel:
      ensure => present,
    }
    ->
    package {'gcc':
      ensure => present,
    }
    ->
    package {'make':
      ensure => present,
    }
    ->
    package {'ssh_scan':
      ensure   => '0.0.18',
      provider => 'puppet_gem',
    }

    file {'/tmp/policy.yml':
      ensure         => 'file',
      checksum       => 'sha256',
    }

    $ssh_66_onward = versioncmp($::sshd_server_version, '6.6') >= 0

    case $ssh_66_onward {
      true: {
        # Newer policy
        File['/tmp/policy.yml'] {
          checksum_value => '58f6c406cc3d6ce3cb73c24ac3067ff05f2f06f1fd597ca1d758354a7b9caef9',
          source         => 'https://raw.githubusercontent.com/mozilla/ssh_scan/e5afaaba89abf60ed6c8885f97da8c9b03e6c2a8/config/policies/mozilla_modern.yml',
        }
      }
      default: {
        # Older policy
        File['/tmp/policy.yml'] {
          checksum_value => '1183328582546789e6098004d455122dcf34ba9c47a7cb3814547639b348bb7f',
          source         => 'https://raw.githubusercontent.com/mozilla/ssh_scan/e5afaaba89abf60ed6c8885f97da8c9b03e6c2a8/config/policies/mozilla_intermediate.yml',
        }
      }
    }

    EOS

    # Run it twice and test for idempotency
    apply_manifest(sqlite_pp, :catch_failures => true)
    apply_manifest(sqlite_pp, :catch_changes => true)
  end

  describe command("/opt/puppetlabs/puppet/bin/ssh_scan -u -t #{fact('ipaddress')} -P /tmp/policy.yml 2>&1") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /"ssh_scan_version": "0.0.18"/ }
  end

end
