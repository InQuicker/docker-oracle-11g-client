FROM debian:jessie

RUN apt-get update && apt-get install -y \
      locales \
      libaio1 \
      unixodbc \
      erlang-odbc

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure -f noninteractive locales

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

COPY ./pkg /tmp

RUN dpkg -i /tmp/oracle-instantclient11.2-basic_11.2.0.4.0-1_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient11.2-odbc_11.2.0.4.0-1_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient11.2-sqlplus_11.2.0.4.0-1_amd64.deb

RUN mkdir -p /etc/oracle

COPY ./etc /etc

ENV ORACLE_HOME /usr/lib/oracle/11.2/client64
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ORACLE_HOME/lib
ENV TNS_ADMIN /etc/oracle

CMD ["bash"]
