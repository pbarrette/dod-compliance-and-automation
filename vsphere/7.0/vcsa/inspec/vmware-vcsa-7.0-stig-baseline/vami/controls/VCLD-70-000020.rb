# encoding: UTF-8

control 'VCLD-70-000020' do
  title 'VAMI must disable directory browsing.'
  desc  "The goal is to completely control the web user's experience in
navigating any portion of the web document root directories. Ensuring all web
content directories have at least the equivalent of an \"index.html\" file is a
significant factor to accomplish this end.

    Enumeration techniques, such as URL parameter manipulation, rely on being
able to obtain information about the web server's directory structure by
locating directories without default pages. In this scenario, the web server
will display to the user a listing of the files in the directory being
accessed. By having a default hosted application web page, the anonymous web
user will not obtain directory browsing information or an error message that
reveals the server type and version.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, execute the following command:

    # /opt/vmware/sbin/vami-lighttpd -p -f
/opt/vmware/etc/lighttpd/lighttpd.conf 2>/dev/null|grep
\"dir-listing.activate\"|sed 's: ::g'

    Expected result:

    dir-listing.activate=\"disable\"

    If the output does not match the expected result, this is a finding.

    Note: The command must be run from a bash shell and not from a shell
generated by the \"appliance shell\". Use the \"chsh\" command to change the
shell for your account to \"/bin/bash\". See KB Article 2100508 for more
details.
  "
  desc  'fix', "
    Navigate to and open:

    /opt/vmware/etc/lighttpd/lighttpd.conf

    Add or reconfigure the following value:

     dir-listing.activate  = \"disable\"

    Restart the service with the following command:

    # vmon-cli --restart applmgmt
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000266-WSR-000142'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'VCLD-70-000020'
  tag fix_id: nil
  tag cci: ['CCI-001312']
  tag nist: ['SI-11 a']

  runtime = command("#{input('lighttpdBin')} -p -f #{input('lighttpdConf')}").stdout

  describe parse_config(runtime).params['dir-listing.activate'] do
    it { should cmp "#{input('dirListingActivate')}" }
  end

end

