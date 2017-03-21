require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'simp/beaker_helpers'
include Simp::BeakerHelpers

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'mozilla_ssh_hardening')
    pluginsync_on( hosts )
    hosts.each do |host|
      if fact('osfamily') == 'Debian'
        # These should be on all Deb-flavor machines by default...
        # But Docker is often more slimline
        shell('apt-get install apt-transport-https software-properties-common -y', { :acceptable_exit_codes => [0] })
      end
      on host, puppet('module', 'install', 'puppetlabs-stdlib -v 4.11.0'), { :acceptable_exit_codes => [0] }
      on host, puppet('module', 'install', 'saz-ssh -v 3.0.1'), { :acceptable_exit_codes => [0] }
    end
  end
end
