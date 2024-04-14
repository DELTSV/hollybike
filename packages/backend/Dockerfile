FROM debian:bookworm-slim

ARG EXECUTABLE

COPY build/native/nativeCompile/$EXECUTABLE /app/hollybike_server

RUN apt-get update && apt-get install -y curl

RUN chmod +x /app/hollybike_server

ENTRYPOINT ["/app/hollybike_server"]
