FROM tomcat:9
# Take the war and copy to webapps of tomcat
COPY target/newapp.war /usr/local/tomcat/webapps/
