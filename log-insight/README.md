# log-insight

## Synopsis

log-insight looks at the logs in /opt/dell/crowbar_framework/logs and reports on the time-series order of the adding and removing of roles on nodes from chef-client runs.

## Use

Copy this to your admin node (/home/crowbar/log-insight.pl, for example)

    chmod 755 /home/crowbar/log-insight.pl

and just run it

    ./log-insight.pl

it produces output you can see at:

http://192.168.124.10:3000/log-insight.html

That is all.

More features, especially grabbing the errors of currently failed nodes, to come.
