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

echo "removing indexci"
ssh $server 'rm -R '$tomcat'/berg.*'

echo "removing old war file"
ssh $server "rm $remotefile"

echo "moving uploads"
ssh $server "mv $remotedir/uploads /root/uploads"

echo "removing static"
ssh $server "rm -R $remotedir"

echo "removing cache"
ssh $server "rm -R $cache/*"

echo "deploying file"
scp $localfile $server:$remotefile

echo "restarting server"
ssh $server '/root/startServer.sh'

echo "putting back uploads"
ssh $server "mv /root/uploads $remotedir/uploads "

echo "removing local build result"
rm $localfile
