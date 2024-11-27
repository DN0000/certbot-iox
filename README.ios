!! Create Virtual Interface for container

```
interface VirtualPortGroup0
 description :: IoX Network ::
 vrf forwarding INET
 ip address 10.128.128.33 255.255.255.224
 ip nat inside


!! Enable NAT for outside interface
interface GigabitEthernet0/0/0
 ip nat outside

!! Allow inbound TCP/80 for certificate validation
!! Allow outbound overload to reach ACME servers
!! Replace 1.1.1.1 as required
ip nat inside source static tcp 10.128.128.34 80 1.1.1.1 80 vrf INET extendable
ip nat inside source list NAT_ACL interface GigabitEthernet0/0/0 vrf INET overload
ip access-list standard NAT_ACL
 10 permit 10.128.128.32 0.0.0.31

!! Enable IOx globally


!! EEM Script to delete, import, and re-apply your trustpoint
!! Update to your requirements
event manager applet INSTALL-CERT
 event syslog pattern "%IM-5-IOX_INST_NOTICE:.*READY TO DEPLOY CERTIFICATE"
 action 0.0.0 cli command "## Credit - https://github.com/techfil/ciscoautocert ##"
 action 020 cli command "enable"
 action 060  syslog msg "Begin certificate install"
 action 070  cli command "config t"
 action 080  cli command "file prompt quiet"
 action 090  cli command "no crypto pki trustpoint SBC" pattern ".*"
 action 100  cli command "yes"
 action 130  cli command "crypto pki import SBC pkcs12 bootflash:/SHARED-IOX/certbot-iox.p12 password cisco" pattern ".*"
 action 140  cli command "yes"
 action 160  cli command "default file prompt"
 action 170  cli command "do delete /force bootflash:/SHARED-IOX/certbot-iox.p12"
 action 190  cli command "sip-ua"
 action 200  cli command "no  crypto signaling default trustpoint SBC"
 action 210  cli command  "crypto signaling default trustpoint SBC"
 action 990  cli command "end"
 action 991  cli command "write"
```

Load up local manager:
    https://1.1.1.1/iox/login

"Add New"
    Application ID: certbot
    Archive:        certbot-iox-xxxx.tar

Wait for upload and Deplyoment sucess message. 

Select "Activate"
    Either manually configure network configuration
        or
    Modify provided "activation.json" and "Activate using resource payload"

Wait for activation completion.

Select "Manage" -> App-Config
    Update Server, Email, and Domains as required
    Save, and Yes


Return to "Applications" and Start certbot.

Logs available within `bootflash:/SHARED-IOX/`


