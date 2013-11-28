#! /bin/bash

projectPath="~/berg"
localfile="~/grails.war"
remotefile="/var/lib/tomcat7/web-apps/ROOT.war"

cd $projectPath
echo "building file"
grails dev war $localfile
echo "deploying file"
scp $localfile root@85.17.248.15:$remotefile
