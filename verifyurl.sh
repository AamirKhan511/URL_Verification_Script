#!/bin/bash
file="/home/m.khan/URL_Verification_Script/textfile.txt"
url=$(grep 'http' $file | cut -d "'" -f 4 | sed s/'URL:\/\/'/''/g)
END=3
regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'


IFS=$'\n'       # make newlines the only separator
for j in $url
  do
	if [[ $j =~ $regex ]]
      then
       	  for i in $(seq 1 $END); do
                if curl -s --head --request GET "$j" | grep "200 OK" > /dev/null; then                     
                    echo $j "is UP"
                    curl -k POST -H 'Content-type: application/json' --data '{"text":"'"$j is UP."'"}' https://hooks.slack.com/services/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
                 else
                    http_response=$(curl -s -o response.txt -w "%{http_code}" $j)
                    if [ $http_response != "200" ]; then
                       echo $j "is DOWN responce code is" $http_response
                       curl -k POST -H 'Content-type: application/json' --data '{"text":"'"$j is Down. Responce code: $http_response"'"}' https://hooks.slack.com/services/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
                    fi
                fi    
            done
     else
        echo "$j IS NOT valid"
    fi
done