# encoding: UTF-8

control 'VCRP-70-000005' do
  title 'The Envoy private key file must be protected from unauthorized access.'
  desc  "Envoy's private key is used to prove the identity of the server to
clients and securely exchange the shared secret key used to encrypt
communications between the web server and clients.

    By gaining access to the private key, an attacker can pretend to be an
authorized server and decrypt the TLS traffic between a client and the web
server.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, execute the following command:

    # stat -c \"%n permisions are %a, is owned by %U and group owned by %G\"
/etc/vmware-rhttpproxy/ssl/rui.key

    Expected result:

    /etc/vmware-rhttpproxy/ssl/rui.key permisions are 600, is owned by root and
group owned by root

    If the output does not match the expected result, this is a finding.
  "
  desc  'fix', "
    At the command prompt, execute the following commands:

    # chmod 600 /etc/vmware-rhttpproxy/ssl/rui.key
    # chown root:root /etc/vmware-rhttpproxy/ssl/rui.key

  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000176-WSR-000096'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'VCRP-70-000005'
  tag fix_id: nil
  tag cci: ['CCI-000186']
  tag nist: ['IA-5 (2) (b)']

  describe file("#{input('sslKey')}") do
    its('mode') { should cmp '0600' }
    its('owner') {should cmp 'root'}
    its('group') {should cmp 'root'}
  end

end

