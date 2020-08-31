while true;do
        instan=$(pgrep -f sshd:)
	[[ "$(echo "$instan")" == '' ]] && kill $(pgrep -f "nginx: master")
	sleep 5s
done
