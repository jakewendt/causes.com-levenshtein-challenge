#!/bin/sh -x

#	setup ...
#	echo "causes" > newfriends
#	grep -vs causes levenshtein.list > indifferents


if [ -f 'indifferents' -a -f 'newfriends' ]; then
	while [ `cat newfriends | wc -l` -gt 0 ] ; do
		newfriend=`head -1 newfriends`
		echo "Processing new friend '${newfriend}'"
		tail +2 newfriends > newfriends.tmp
		mv newfriends.tmp newfriends
		echo $newfriend >> friends



#		convert "causes" to ".causes|.?auses|c.?uses|ca.?ses|cau.?es|caus.?s|cause.?|causes."
		regex=".causes|.?auses|c.?uses|ca.?ses|cau.?es|caus.?s|cause.?|causes."

#	everything is waiting on this ^^^^






		#	yay! script converts the "s to 's
		grep -E "^($regex)$" indifferents >> newfriends
		grep -vs -E "^($regex)$" indifferents > indifferents.tmp
		mv indifferents.tmp indifferents
	done
else
	echo "indifferents or newfriends file not found"
fi
