FROM docker:18.09.6

LABEL maintainer="Alexander Litvinenko <array.shift@yahoo.com>"

ENV APP_NAME cicd
ENV APP_INSTALL_PATH /opt/${APP_NAME}
ENV REPORT_CONVERTER_VERSION 0.4

ENV START_HTTPS_SERVER true
ENV SSL_CERT_FILE certificate.crt
ENV SSL_KEY_FILE private.key
ENV SSL_CHAIN_FILE ""
ENV START_CRON true

COPY scripts ${APP_INSTALL_PATH}
COPY configs ${APP_INSTALL_PATH}
COPY webapp ${APP_INSTALL_PATH}/runtime
COPY utils ${APP_INSTALL_PATH}/utils
COPY templates ${APP_INSTALL_PATH}/templates

RUN chmod -R 777 ${APP_INSTALL_PATH}
RUN ${APP_INSTALL_PATH}/buildtime/init.sh

EXPOSE 3000/tcp

ENTRYPOINT [ "start.sh" ]