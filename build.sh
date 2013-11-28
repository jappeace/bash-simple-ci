#! /bin/bash


projectPath="$HOME/berg"
localfile="$HOME/grails.war"
remotefile="/var/lib/tomcat7/webapps/ROOT.war"
server=root@85.17.248.15

cd $projectPath
echo "building file"
grails dev war $localfile
echo "deploying file"
scp $localfile $server:$remotefile
echo "restarting server"
ssh $server 'service tomcat7 restart'
echo "removing local build result"
rm $localfile
