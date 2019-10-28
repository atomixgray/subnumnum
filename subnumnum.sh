#!/bin/bash

echo  @_at0mix
echo " _____       _       _   _                   _   _                 ";
echo "/  ___|     | |     | \ | |                 | \ | |                ";
echo "\ \`--. _   _| |__   |  \| |_   _ _ __ ___   |  \| |_   _ _ __ ___  ";
echo " \`--. \ | | | '_ \  | . \` | | | | '_ \` _ \  | . \` | | | | '_ \` _ \ ";
echo "/\__/ / |_| | |_) | | |\  | |_| | | | | | | | |\  | |_| | | | | | |";
echo "\____/ \__,_|_.__/  \_| \_/\__,_|_| |_| |_| \_| \_/\__,_|_| |_| |_|";
echo "                                                                   ";
echo "                                                                   ";

# Ask for URL please
echo Please enter your URL
read varname
echo Running Recon on $varname Please Wait . . This will take sometime.
 
#echo Searching crt.sh for Subdomains
sudo curl -s https://crt.sh/?q=%25.$varname > /tmp/$varname+curl.out

sudo cat /tmp/$varname+curl.out | grep $varname | grep TD | sed -e 's/<//g' | sed -e 's/>//g' | sed -e 's/TD//g' | sed -e 's/\///g' | sed -e 's/ //g' | sed -n '1!p' | sort -u > $varname-crt.txt

#echo Searching certspotter.com for Subdomains
sudo curl -s https://certspotter.com/api/v0/certs\?domain\=$varname | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $varname >> $varname-crt.txt

#echo URL Scan
sudo curl -s https://urlscan.io/api/v1/search/?q=domain:$varname > /tmp/$varname+urlscan.out
sudo grep -Eo '(http|https)://[^/"]+' /tmp/$varname+urlscan.out | sort -u | grep $varname >> $varname-crt.txt

#echo Way Back
sudo curl -s https://web.archive.org/cdx/search/cdx?url=*.$varname > /tmp/$varname+wayback.out
sudo grep -Eo '(http|https)://[^/"]+' /tmp/$varname+wayback.out | sort -u | grep $varname >> $varname-crt.txt


#echo Checking to see if SubDomains are Online

sudo cat $varname-crt.txt | sort -u | /root/go/bin/httprobe -c 50 -t 3000 > $varname-alive.txt

echo Starting Brute Force on  $varname-alive.txt
sudo  /root/tools/dirsearch/dirsearch.py -L $varname-alive.txt -e html,json -x 400,500,503,301,302 -b

echo  .....Cleaning up files.... 
sleep 2
echo  Please open file $varname-alive.txt to review results.
sudo rm /tmp/$varname+curl.out
sudo rm  $varname-crt.txt 
sudo rm /tmp/$varname+urlscan.out
sudo rm /tmp/$varname+wayback.out
