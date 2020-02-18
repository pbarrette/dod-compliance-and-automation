control "VCFL-67-000030" do
  title "vSphere Client must set the secure flag for cookies."
  desc  "The secure flag is an option that can be set by the application server
when sending a new cookie to the user within an HTTP Response. The purpose of
the secure flag is to prevent cookies from being observed by unauthorized
parties due to the transmission of a the cookie in clear text. By setting the
secure flag, the browser will prevent the transmission of a cookie over an
unencrypted channel."
  impact 0.5
  tag severity: "CAT II"
  tag gtitle: "SRG-APP-000439-WSR-000155"
  tag gid: nil
  tag rid: "VCFL-67-000030"
  tag stig_id: "VCFL-67-000030"
  tag cci: "CCI-002418"
  tag nist: ["SC-8", "Rev_4"]
  desc 'check', "At the command prompt, execute the following command:

# xmllint --format
/usr/lib/vmware-vsphere-client/server/configuration/conf/web.xml | sed
's/xmlns=\".*\"//g' | xmllint --xpath
'/web-app/session-config/cookie-config/secure' -

Expected result:

<secure>true</secure>

If the output of the command does not match the expected result, this is a
finding."
  desc 'fix', "Navigate to and open
/usr/lib/vmware-vsphere-client/server/configuration/conf/web.xml

Navigate to the /<web-apps>/<session-config>/<cookie-config> node and configure
it as follows.

    <cookie-config>
      <http-only>true</http-only>
      <secure>true</secure>
    </cookie-config>"

  describe xml('/usr/lib/vmware-vsphere-client/server/configuration/conf/web.xml') do
    its('/web-app/session-config/cookie-config/secure') { should cmp 'true' }
  end

end