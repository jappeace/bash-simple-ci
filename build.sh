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

echo "removing static"
ssh $server "find $remotedir -mindepth 1 -maxdepth 1 -not -name 'uploads' | xargs rm -R"


echo "removing cache"
ssh $server "rm -R $cache/*"

echo "deploying file"
scp $localfile $server:$remotefile

echo "restarting server"
ssh $server '/root/startServer.sh'

echo "removing local build result"
rm $localfile
