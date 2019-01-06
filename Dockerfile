FROM openjdk:8-jdk

RUN echo 'deb http://ftp.de.debian.org/debian jessie main' >> /etc/apt/sources.list
RUN echo 'deb http://security.debian.org/debian-security jessie/updates main ' >> /etc/apt/sources.list
RUN echo 'deb http://ftp.de.debian.org/debian sid main' >> /etc/apt/sources.list

WORKDIR /root

RUN apt-get update

RUN apt-get install -y git
RUN apt-get install -y vim

RUN apt-get install -y maven

ARG maven
RUN mkdir /root/.m2
RUN echo $maven > /root/.m2/settings.xml

ARG mongo_db_key
ENV MONGODB_KEY=$(mongo_db_key)

WORKDIR /root
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.2.1/wait /wait
RUN chmod +x /wait

COPY . /root/search-indexer
WORKDIR /root/search-indexer

RUN mvn clean install -DskipTests
RUN chmod +x build.sh
