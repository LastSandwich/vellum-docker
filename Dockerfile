FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

ARG bedrockVersion=latest
ARG vellumVersion=v1.3.1-beta
ARG vellumBuild=212

ENV version=$bedrockVersion
ENV vellumVersion=${vellumVersion}
ENV vellumBuild=${vellumBuild}

RUN apt-get update && \
    apt-get install -y unzip curl libgdiplus libc6-dev

RUN mkdir bedrock-server
RUN if [ "$version" = "latest" ] ; then \
        LATEST_VERSION=$( \
            curl -v --silent  https://www.minecraft.net/en-us/download/server/bedrock/ 2>&1 | \
            grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' | \
            sed 's#.*/bedrock-server-##' | sed 's/.zip//') && \
        export version=$LATEST_VERSION && \
        echo "Setting VERSION to $LATEST_VERSION" ; \
    else echo "Using VERSION of $bedrockVersion"; \
    fi && \
    curl https://minecraft.azureedge.net/bin-linux/bedrock-server-${version}.zip --output bedrock-server.zip && \
    unzip bedrock-server.zip -d bedrock-server && \
    rm bedrock-server.zip && \
    curl -L --fail https://github.com/clarkx86/vellum/releases/download/${vellumVersion}/vellum_linux-x64_${vellumVersion}-${vellumBuild}.zip --output vellum.zip && \
    unzip vellum.zip -d bedrock-server && \
    rm vellum.zip

RUN mkdir /bds && \
    mkdir /bds/config && \
    mkdir /bds/backup && \
    mv /bedrock-server/server.properties /bds/config && \
    mv /bedrock-server/permissions.json /bds/config && \
    mv /bedrock-server/whitelist.json /bds/config && \
    ln -s /bds/config/server.properties /bedrock-server/server.properties && \
    ln -s /bds/config/permissions.json /bedrock-server/permissions.json && \
    ln -s /bds/config/whitelist.json /bedrock-server/whitelist.json && \
    ln -s /bds/config/configuration.json /bedrock-server/configuration.json && \
    ln -s /bds/worlds /bedrock-server/worlds && \
    ln -s /bds/backup /bedrock-server/backup

RUN chmod 755 /bedrock-server/backup

EXPOSE 19132
WORKDIR /bedrock-server

RUN chmod +x ./bedrock_server
RUN chmod +x ./vellum

CMD ./vellum -c ./configuration.json
