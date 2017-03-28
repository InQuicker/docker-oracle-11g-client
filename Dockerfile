FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && \
      apt-get -y --no-install-recommends install \
        locales \
        libaio1 \
        unixodbc \
        erlang-odbc

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
      locale-gen en_US.UTF-8 && \
      dpkg-reconfigure -f noninteractive locales

ENV LANGUAGE="en_US.UTF-8" LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8"

COPY ./pkg /tmp

RUN dpkg -i /tmp/oracle-instantclient11.2-basic_11.2.0.4.0-1_amd64.deb \
            /tmp/oracle-instantclient11.2-odbc_11.2.0.4.0-1_amd64.deb \
            /tmp/oracle-instantclient11.2-sqlplus_11.2.0.4.0-1_amd64.deb

RUN mkdir -p /etc/oracle

COPY ./etc /etc

ENV ORACLE_HOME="/usr/lib/oracle/11.2/client64" \
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ORACLE_HOME/lib" \
    TNS_ADMIN="/etc/oracle"

CMD ["bash"]
