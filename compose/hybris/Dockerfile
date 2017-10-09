FROM centos:centos7

LABEL maintainer="michael@mertisconsulting.com"

RUN yum -y install wget unzip lsof

#
# Install Java
# To get the url, go to the Oracle site, agree to the license, and copy the url.
ENV JAVA_URL=http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.rpm

RUN wget -c -O /tmp/jdk.rpm --header "Cookie: oraclelicense=accept-securebackup-cookie" ${JAVA_URL} \
   && yum -y localinstall /tmp/jdk.rpm \
   && export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::") \
   && rm -f /tmp/jdk.rpm

#
# Open the ports that Hybris will use
#
EXPOSE 9001
EXPOSE 9002

#
# Unzip the hybris source file
#
WORKDIR /srv
COPY ./media/hybris.zip /tmp/hybris.zip
RUN unzip /tmp/hybris.zip; exit 0 && rm /tmp/hybris.zip

#
# Execute Hybris installer with B2B/CPQ recipe
#
WORKDIR /srv/installer
RUN export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::") \
   && ./install.sh -r b2c_b2b_acc_cpq

#
# Copy mysql driver
#
COPY ./media/cpq/mysql*.jar /srv/hybris/bin/platform/lib/dbdriver/.

#
# Specify the files to use for the CPQ engine and dataloader
#
ENV CPQ_ENGINE=FBSSLCENGINE05P_5-70000644.zip
ENV CPQ_DATALOADER=FBSSOLDATBS05P_5-70000643.zip

#
# The dataloader and engine jars go in the sapproductconfigmodel/lib/ directory
#
WORKDIR /srv/hybris/bin/ext-integration/sap/productconfig/sapproductconfigmodel/lib/
COPY ./media/cpq/${CPQ_ENGINE} .
COPY ./media/cpq/${CPQ_DATALOADER} .
RUN unzip ${CPQ_DATALOADER}; exit 0 && unzip ${CPQ_ENGINE}; exit 0 && rm *.zip

#
# The engine jars go int othe sapproductconfigruntimessc/lib/ directory
#
WORKDIR /srv/hybris/bin/ext-integration/sap/productconfig/sapproductconfigruntimessc/lib/
COPY ./media/cpq/${CPQ_ENGINE} .
RUN unzip ${CPQ_ENGINE}; exit 0 && rm ${CPQ_ENGINE}

#
# Specify the Hybris UI extensions to use
# Extensions are installed in the hybris/bin/custom/ directory
#
ARG CPQ_HYBRIS_UI=FBSSOLHYUIEX6300P_3-70002595.zip

WORKDIR /srv/hybris/bin/custom/
COPY ./media/cpq/${CPQ_HYBRIS_UI} .
RUN unzip ${CPQ_HYBRIS_UI}; exit 0 && rm ${CPQ_HYBRIS_UI}

#
# Use specific configuration files
#
COPY ./media/local.properties /srv/hybris/config/.
COPY ./media/localextensions.xml /srv/hybris/config/.

#
# Build the Hybris suite
#
WORKDIR /srv/hybris/bin/platform
RUN export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::") \
   && . ./setantenv.sh \
   && ant clean all

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
