#check if nginx and sshd are running
while true;do
        ssh_running=$(pgrep sshd:)
	[[ "$(echo "$ssh_running")" == '' ]]
	sleep 5s
done
