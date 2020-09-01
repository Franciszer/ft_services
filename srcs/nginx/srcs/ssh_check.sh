while true;do
        ssh_running=$(pgrep -f sshd:)
	[[ "$(echo "$ssh_running")" == '' ]] && kill $(pgrep -f "nginx: master")
	sleep 5s
done
