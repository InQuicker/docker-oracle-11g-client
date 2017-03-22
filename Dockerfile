FROM debian:jessie

RUN locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update && apt-get install -y \
			unixodbc \
			erlang-odbc

COPY ./pkg /tmp

RUN dpkg -i /tmp/oracle-instantclient11.2-basic_11.2.0.4.0-1_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient11.2-odbc_11.2.0.4.0-1_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient11.2-sqlplus_11.2.0.4.0-1_amd64.deb

COPY ./etc/odbcinst.ini /etc
COPY ./etc/odbc.ini /etc
COPY ./etc/tnsnames.ora /etc/oracle

ENV ORACLE_HOME /usr/lib/oracle/11.2/client64
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ORACLE_HOME/lib
ENV TNS_ADMIN /etc/oracle

CMD ["bash"]
