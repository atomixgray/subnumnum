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
echo Running Sub Num Num on $varname
 
echo Searching crt.sh for Subdomains
sudo curl -s https://crt.sh/?q=%25.$varname > /tmp/$varname+curl.out

sudo cat /tmp/$varname+curl.out | grep $varname | grep TD | sed -e 's/<//g' | sed -e 's/>//g' | sed -e 's/TD//g' | sed -e 's/\///g' | sed -e 's/ //g' | sed -n '1!p' | sort -u > $varname-crt.txt

echo Searching certspotter.com for Subdomains
sudo curl -s https://certspotter.com/api/v0/certs\?domain\=$varname | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $varname >> $varname-crt.txt

echo checking to see if subdomains are online

# Might need to change Go path below 
cat $varname-crt.txt | /root/go/bin/httprobe  | sort -u > $varname-alive.txt

echo  Cleaning up files.... 
sudo rm /tmp/$varname+curl.out
sudo rm  $varname-crt.txt 
