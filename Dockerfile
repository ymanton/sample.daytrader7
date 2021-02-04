FROM open-liberty:full
ARG VERBOSE=false

COPY --chown=1001:0 daytrader-ee7-wlpcfg/servers/daytrader7Sample/server.xml /config/server.xml
COPY --chown=1001:0 daytrader-ee7-wlpcfg/servers/daytrader7Sample/apps/daytrader-ee7.ear /config/apps/daytrader-ee7.ear
COPY --chown=1001:0 daytrader-ee7-wlpcfg/shared/resources/Daytrader7SampleDerbyLibs/derby-10.10.1.1.jar /opt/ol/wlp/usr/shared/resources/Daytrader7SampleDerbyLibs/derby-10.10.1.1.jar

# This directory doesn't exist initially and needs to be manually created.
# Steps:
#  Build the image
#  Run the container, e.g.: docker run --rm -it -p 9082:9082 -v $PWD/data:/opt/ol/wlp/usr/shared/resources/data:rw
#  Navigate to the app, e.g.: http://<ip>:9082/daytrader
#  Initialize the database via the Configuration tab:
#   Click on '(Re)-create DayTrader Database Tables and Indexes' to create the database.
#   Click on '(Re)-populate DayTrader Database' to populate the database.
# Once that's done data/tradedb should exist
# Rebuild the image
ADD --chown=1001:0 data /opt/ol/wlp/usr/shared/resources/data

# Logging vars
ENV LOGGING_FORMAT=simple
ENV ACCESS_LOGGING_ENABLED=false
ENV TRACE_SPEC=*=info

# Build SCC?
ARG CREATE_OPENJ9_SCC=true
ENV OPENJ9_SCC=${CREATE_OPENJ9_SCC}

RUN configure.sh
