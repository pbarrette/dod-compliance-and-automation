control 'VCEM-70-000030' do
  title 'ESX Agent Manager must set the secure flag for cookies.'
  desc  "
    The secure flag is an option that can be set by the application server when sending a new cookie to the user within an HTTP Response. The purpose of the secure flag is to prevent cookies from being observed by unauthorized parties due to the transmission of a cookie in clear text.

    By setting the secure flag, the browser will prevent the transmission of a cookie over an unencrypted channel. The ESX Agent Manager is configured to only be accessible over a TLS tunnel, but this cookie flag is still a recommended best practice.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, execute the following command:

    # xmllint --format /usr/lib/vmware-eam/web/webapps/eam/WEB-INF/web.xml | sed 's/xmlns=\".*\"//g' | xmllint --xpath '/web-app/session-config/cookie-config/secure' -

    Expected result:

    <secure>true</secure>

    If the output of the command does not match the expected result, this is a finding.
  "
  desc 'fix', "
    Navigate to and open:

    /usr/lib/vmware-eam/web/webapps/eam/WEB-INF/web.xml

    Navigate to the /<web-apps>/<session-config>/<cookie-config> node and configure it as follows:

        <cookie-config>
          <http-only>true</http-only>
          <secure>true</secure>
        </cookie-config>

    Restart the service with the following command:

    # vmon-cli --restart eam
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000380-WSR-000072'
  tag gid: 'V-256702'
  tag rid: 'SV-256702r888662_rule'
  tag stig_id: 'VCEM-70-000030'
  tag cci: ['CCI-001813']
  tag nist: ['CM-5 (1)']

  describe xml("#{input('webXmlPath')}") do
    its('/web-app/session-config/cookie-config/secure') { should cmp 'true' }
  end
end
