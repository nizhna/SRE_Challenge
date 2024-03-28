#!/bin/bash

#usage: ./script.sh website.com
#website.com is the website that should be checked

#getting the name of the website and saving it as a variable
website=$1;

#performing infinite loop to check website loading time as long as we need
#still, can be paused by Ctrl + C when necessary to stop
while :
do
	#creating the variable with the total time the website loads using curl
	upload_t=$(curl -w 'Total Time:\t\t%{time_total}\n' -o /dev/null -s https://$website/ | awk '{ print $3 }');
	#creating the condition to send the notification to Slack channel
	if (( $(echo "$upload_t > 1.4" | bc -l) ))
	then
		#sending the notification to Slack channel using curl
                #btw, this was tested with a real channel ID and token in a Slack channel, I'm simply withholding those for privacy :)
		curl -d "text=Alert, the website "$website" is loading slowly. Load time is: "$upload_t" seconds." -d "channel=C123456" -H "Authorization: Bearer xoxb-not-a-real-token-this-will-not-work" -X POST https://slack.com/api/chat.postMessage -o /dev/null -s ;
	fi
	#giving some break to avoid overload due to the script
	sleep 3;
done

