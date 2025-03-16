FROM mcr.microsoft.com/dotnet/aspnet:6.0

ARG bedrockVersion=1.21.62.01
ARG vellumVersion=v0.1.6

ENV version=$bedrockVersion
ENV vellumVersion=${vellumVersion}

RUN apt-get update && \
    apt-get install -y unzip curl libgdiplus libc6-dev

RUN mkdir bedrock-server

RUN if [ "$version" = "latest" ] ; then \
        LATEST_VERSION=$( \
            curl -sSL https://mc-bds-helper.vercel.app/api/latest | \
            grep -o 'https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-[^"]*.zip' | \
            sed 's#.*/bedrock-server-##; s/.zip$//') && \
        export version=$LATEST_VERSION && \
        echo "Setting VERSION to $LATEST_VERSION" ; \
    else echo "Using VERSION of $bedrockVersion"; \
    fi && \
    curl https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-${version}.zip -A "lastsandwich/minecraft-bedrock-server" --output bedrock-server.zip && \
    unzip bedrock-server.zip -d bedrock-server && \
    rm bedrock-server.zip && \
    curl -L --fail https://github.com/LastSandwich/vellum/releases/download/${vellumVersion}/vellum_linux-x64_${vellumVersion}.zip --output vellum.zip && \
    unzip vellum.zip -d bedrock-server && \
    rm vellum.zip

RUN mkdir /bds && \
    mkdir /bds/config && \
    mkdir /bds/backup && \
    mv /bedrock-server/server.properties /bds/config && \
    mv /bedrock-server/permissions.json /bds/config && \
    mv /bedrock-server/allowlist.json /bds/config && \
    ln -s /bds/config/server.properties /bedrock-server/server.properties && \
    ln -s /bds/config/permissions.json /bedrock-server/permissions.json && \
    ln -s /bds/config/allowlist.json /bedrock-server/allowlist.json && \
    ln -s /bds/config/configuration.json /bedrock-server/configuration.json && \
    ln -s /bds/worlds /bedrock-server/worlds && \
    ln -s /bds/backup /bedrock-server/backup && \
    ln -s /bds/backup /bedrock-server/backup

RUN chmod 755 /bedrock-server/backup

EXPOSE 19132
WORKDIR /bedrock-server

RUN chmod +x ./bedrock_server
RUN chmod +x ./vellum

CMD ./vellum -c ./configuration.json
