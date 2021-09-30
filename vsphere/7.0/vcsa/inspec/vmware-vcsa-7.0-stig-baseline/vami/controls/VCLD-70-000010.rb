# encoding: UTF-8

control 'VCLD-70-000010' do
  title 'VAMI must only load allowed server modules.'
  desc  "A web server can provide many features, services, and processes. Some
of these may be deemed unnecessary or too unsecure to run on a production DoD
system.

    VAMI can be configured to load any number of external modules, but only a
specific few are provided and supported by VMware. Additional, unexpected
modules must be removed.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, execute the following command:

    # /opt/vmware/sbin/vami-lighttpd -p -f
/opt/vmware/etc/lighttpd/lighttpd.conf 2>/dev/null|awk
'/server\\.modules/,/\\)/'|sed -e 's/^[ ]*//'

    Expected result:

    server.modules=(
    \"mod_access\",
    \"mod_accesslog\",
    \"mod_proxy\",
    \"mod_cgi\",
    \"mod_rewrite\",
    \"mod_magnet\",
    \"mod_setenv\",
    #7
    )

    If the output does not match the expected result, this is a finding.

    Note: The command must be run from a bash shell and not from a shell
generated by the \"appliance shell\". Use the \"chsh\" command to change the
shell for your account to \"/bin/bash\". See KB Article 2100508 for more
details.
  "
  desc  'fix', "
    Navigate to and open:

    /opt/vmware/etc/lighttpd/lighttpd.conf

    Configure the \"server.modules\" section to the following:

    server.modules = (
      \"mod_access\",
      \"mod_accesslog\",
      \"mod_proxy\",
      \"mod_cgi\",
      \"mod_rewrite\",
    )
    server.modules += ( \"mod_magnet\" )

    Restart the service with the following command:

    # vmon-cli --restart applmgmt
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000141-WSR-000075'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'VCLD-70-000010'
  tag fix_id: nil
  tag cci: ['CCI-000381']
  tag nist: ['CM-7 a']

  list = ["\"mod_access\",", "\"mod_accesslog\",", "\"mod_proxy\",", "\"mod_cgi\",", "\"mod_rewrite\",", "\"mod_magnet\",", "\"mod_setenv\","]
  command("/opt/vmware/sbin/vami-lighttpd -p -f /opt/vmware/etc/lighttpd/lighttpd.conf 2>/dev/null|awk '/server\.modules/,/\)/'|sed -e 's/^[ ]*//'|grep mod_").stdout.split.each do | result |
    describe result do
      it { should be_in list }
    end
  end

end

