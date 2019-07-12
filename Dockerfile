FROM docker:18.09.6

LABEL maintainer="Alexander Litvinenko <array.shift@yahoo.com>"

ENV APP_NAME cicd
ENV APP_INSTALL_PATH /opt/${APP_NAME}

COPY scripts ${APP_INSTALL_PATH}
COPY configs ${APP_INSTALL_PATH}
COPY app ${APP_INSTALL_PATH}/runtime

RUN chmod -R 777 ${APP_INSTALL_PATH}
RUN ${APP_INSTALL_PATH}/buildtime/init.sh

EXPOSE 3000/tcp

ENTRYPOINT [ "start.sh" ]