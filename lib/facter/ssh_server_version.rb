Facter.add('sshd_server_version') do
  confine :kernel => %w(Linux SunOS FreeBSD Darwin)

  setcode do
    if Facter::Util::Resolution.which('sshd')
      # sshd doesn't actually have a -V option (hopefully one will be added),
      # by happy coincidence the usage information that is printed includes the
      # version number.
      version = Facter::Util::Resolution.exec('sshd -V 2>&1').
                lines.
                to_a.
                select { |line| line.match(%r{^OpenSSH_}) }.
                first.
                rstrip

      version.gsub(%r{^OpenSSH_([\d.]{2,}[p][\d]).*$}, '\1') unless version.nil?
    end
  end
end
