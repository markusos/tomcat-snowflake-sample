FROM maven:3.8.1-jdk-11 AS build

# Copy project files
WORKDIR /app
COPY pom.xml .
COPY src ./src
# COPY webapp ./webapp

# Build the WAR file
RUN mvn package -X

FROM tomcat:9.0-jdk11

RUN apt-get update && apt-get install -y wget

COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/

# Download the Snowflake JDBC driver
RUN wget -O /usr/local/tomcat/lib/snowflake-jdbc-3.21.0.jar https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.21.0/snowflake-jdbc-3.21.0.jar

# Copy the startup script
COPY startup.sh /usr/local/tomcat/bin/
RUN chmod +x /usr/local/tomcat/bin/startup.sh

# Expose the Tomcat port
EXPOSE 8080

CMD ["/usr/local/tomcat/bin/startup.sh"]
