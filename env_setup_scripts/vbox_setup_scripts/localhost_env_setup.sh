#!/usr/bin/env bash

echo '### turn off DNS lookups on ssh-server because theyre slow'
echo "UseDNS no" >> /etc/ssh/sshd_config
service ssh restart

echo ### add passwordless sudo to crowbar user
echo "crowbar ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo ### set shell to VI mode, as Judd prefers
echo "set -o vi" >> ~/.bash_login
echo "set -o vi" >> ~/.bashrc

echo ### install tmux, the better screen
apt-get -y install tmux
wait
dpkg --configure -a
wait
dpkg --configure -a

exit 0

#__END__

# extra stuff

# setup a tmux session with some useful apps

tmux new-session -d -s crowbardev
tmux new-window -t crowbardev:1 -n 'devrun' 
tmux send-keys 'cd /opt/dell/bin/; sudo ./dev_mode.sh' 'C-m'
tmux split-window -v 
tmux send-keys 'cd /var/log/' 'C-m'
tmux -2 attach-session -t crowbardev

