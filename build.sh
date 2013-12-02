#! /bin/bash

projectPath="$HOME/berg"
localfile="$HOME/grails.war"
tomcat="/var/lib/tomcat7"
remotedir="$tomcat/webapps/ROOT"
remotefile=$remotedir".war"
cache="$tomcat/work/Catalina"
server=root@85.17.248.15

cd $projectPath
echo "building file"
grails prod war $localfile

echo "stopping server"
ssh $server 'service tomcat7 stop'

echo "removing old war file"
ssh $server "rm $remotefile"

echo "removing static"
ssh $server "rm -R $remotedir"

echo "removing cache"
ssh $server "rm -R $cache/*"

echo "deploying file"
scp $localfile $server:$remotefile

echo "restarting server"
ssh $server 'service tomcat7 start'

echo "removing local build result"
rm $localfile
