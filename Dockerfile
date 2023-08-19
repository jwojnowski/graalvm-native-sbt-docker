ARG sbtVersion
ARG javaVersion
ARG graalVmVersion

FROM alpine/curl AS sbt-downloader
ARG sbtVersion

RUN echo https://github.com/sbt/sbt/releases/download/v${sbtVersion}/sbt-\${sbtVersion}.tgz
RUN curl -L https://github.com/sbt/sbt/releases/download/v${sbtVersion}/sbt-${sbtVersion}.tgz > sbt.tgz
RUN tar xzf sbt.tgz
RUN mv sbt/bin/sbt /usr/bin/sbt

FROM ghcr.io/graalvm/graalvm-ce:ol9-java${javaVersion}-${graalVmVersion}
COPY --from=sbt-downloader /usr/bin/sbt /usr/bin/sbt
RUN chmod u+x /usr/bin/sbt
RUN echo c | sbt sbtVersion
RUN gu install native-image
