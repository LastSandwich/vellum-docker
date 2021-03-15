FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

ARG bedrockVersion=1.16.210.06
ARG vellumVersion=v1.3.1-beta
ARG vellumBuild=212

ENV bedrockVersion=${bedrockVersion}
ENV vellumVersion=${vellumVersion}
ENV vellumBuild=${vellumBuild}

RUN apt-get update && \
    apt-get install -y unzip curl libgdiplus libc6-dev

RUN mkdir bedrock-server
RUN if [ "$bedrockVersion" = "latest" ] ; then \
        LATEST_VERSION=$( \
            curl -v --silent  https://www.minecraft.net/en-us/download/server/bedrock/ 2>&1 | \
            grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' | \
            sed 's#.*/bedrock-server-##' | sed 's/.zip//') && \
        export VERSION=$LATEST_VERSION && \
        echo "Setting VERSION to $LATEST_VERSION" ; \
    else echo "Using VERSION of $bedrockVersion"; \
    fi && \
    curl https://minecraft.azureedge.net/bin-linux/bedrock-server-${bedrockVersion}.zip --output bedrock-server.zip && \
    unzip bedrock-server.zip -d bedrock-server && \
    rm bedrock-server.zip && \
    curl -L --fail https://github.com/clarkx86/vellum/releases/download/${vellumVersion}/vellum_linux-x64_${vellumVersion}-${vellumBuild}.zip --output vellum.zip && \
    unzip vellum.zip -d bedrock-server && \
    rm vellum.zip && \
    mkdir /bedrock-server/config && \
        mv /bedrock-server/server.properties /bedrock-server/config && \
        mv /bedrock-server/permissions.json /bedrock-server/config && \
        mv /bedrock-server/whitelist.json /bedrock-server/config && \
        ln -s /bedrock-server/config/server.properties /bedrock-server/server.properties && \
        ln -s /bedrock-server/config/permissions.json /bedrock-server/permissions.json && \
        ln -s /bedrock-server/config/whitelist.json /bedrock-server/whitelist.json && \
        ln -s /bedrock-server/config/configuration.json /bedrock-server/configuration.json

EXPOSE 19132
WORKDIR /bedrock-server
CMD ./vellum -c ./config/configuration.json
