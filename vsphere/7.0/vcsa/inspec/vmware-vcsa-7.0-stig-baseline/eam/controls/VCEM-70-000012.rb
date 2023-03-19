control 'VCEM-70-000012' do
  title 'ESX Agent Manager must have Multipurpose Internet Mail Extensions (MIMEs) that invoke operating system shell programs disabled.'
  desc  'MIME mappings tell ESX Agent Manager what type of program various file types and extensions are and what external utilities or programs are needed to execute the file type. By ensuring that various shell script MIME types are not included in web.xml, the server is protected against malicious users tricking the server into executing shell command files.'
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, execute the following command:

    # grep -En '(x-csh<)|(x-sh<)|(x-shar<)|(x-ksh<)' /usr/lib/vmware-eam/web/webapps/eam/WEB-INF/web.xml

    If the command produces any output, this is a finding.
  "
  desc 'fix', "
    Navigate to and open:

    /usr/lib/vmware-eam/web/webapps/eam/WEB-INF/web.xml

    Remove any and all of the following nodes lines:

    <mime-type>application/x-csh</mime-type>
    <mime-type>application/x-shar</mime-type>
    <mime-type>application/x-sh</mime-type>
    <mime-type>application/x-ksh</mime-type>

    Restart the service with the following command:

    # vmon-cli --restart eam

    Note: Delete the entire mime-mapping node for the target mime-type.

    Example:

    <mime-mapping>
        <extension>sh</extension>
        <mime-type>application/x-sh</mime-type>
    </mime-mapping>
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000141-WSR-000081'
  tag gid: 'V-256684'
  tag rid: 'SV-256684r888608_rule'
  tag stig_id: 'VCEM-70-000012'
  tag cci: ['CCI-000381']
  tag nist: ['CM-7 a']

  describe command("grep -En \'(x-csh<)|(x-sh<)|(x-shar<)|(x-ksh<)\' '#{input('webXmlPath')}'") do
    its('stdout.strip') { should eq '' }
  end
end
