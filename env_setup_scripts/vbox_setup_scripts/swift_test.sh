#!/usr/bin/env bats

@test "ssh to the admin node as crowbar" (
  ssh crowbar@admin hostname
}

@test "find the swift proxy servers" {
  ssh crowbar@admin /opt/dell/bin/crowbar 

@test "is service up at all?"
exit 0

1) $ swift -V 2 -A http://keystone server:5000/v2.0 -U admin:admin -K crowbar --verbose stat

2) Create a nice sized file with plenty of randomness and grab a checksum:

crowbar@d08-00-27-cf-03-a3:~$ dd if=/var/log/syslog of=garbage count=2000 1547+1 records in 1547+1 records out 792094 bytes (792 kB) copied, 0.0132542 s, 59.8 MB/s crowbar@d08-00-27-cf-03-a3:~$ md5sum garbage 6f23ae4396da7ffdfcfd7d61ae7a0862 garbage

# authenticate, create container, create object, put all the verbose output into create_object file

$ swift -V 2 -A http://keystone server:5000/v2.0 -U admin:admin -K crowbar --verbose --debug upload testcontainer garbage 2>&1 &> create_object_output

# inspect create_object file, note proxy written to in last stanza

DEBUG:swiftclient:REQ: curl -i https://192.168.126.3:8080/v1/AUTH_cb48955beb424f9383fb5d1e8de2628c/testcontainer/garbage -X PUT -H "X-Auth-Token: MIIMfAYJKoZ ... [snip]"

# edit curl statement to get the file from the other proxy # note changes: # -o is the output filename: garbage_new # ip address of other swift-proxy # adding -k to overlook ssl certificate issues # removing -i so we don't get http headers in our new file # changing -X PUT to -X GET

crowbar@d08-00-27-0c-b0-2c:~/blah$ curl -o garbage_new -k https://192.168.126.4:8080/v1/AUTH_cb48955beb424f9383fb5d1e8de2628c/testcontainer/garbage -X GET -H "X-Auth-Token: MIIMfAYJKoZIhv

# desired output: (none)

# compare the new and old files: crowbar@d08-00-27-cf-03-a3:~$ md5sum garbage* 6f23ae4396da7ffdfcfd7d61ae7a0862 garbage 6f23ae4396da7ffdfcfd7d61ae7a0862 garbage_new

Same contents!

# edit curl statement again to test that the change of host really works # by creating an intentional host connect timeout # note changes: # change ip address of swift-proxy (to a host that is not running swift-proxy)

crowbar@d08-00-27-0c-b0-2c:~/blah$ curl -o garbage_new -k https://192.168.126.4:8080/v1/AUTH_cb48955beb424f9383fb5d1e8de2628c/testcontainer/garbage -X GET -H "X-Auth-Token: MIIMfAYJKoZIhv ... [snip]

# desired output:

curl: (7) couldn't connect to host
