FROM debian:bookworm-slim

ARG EXECUTABLE

COPY build/native/nativeCompile/$EXECUTABLE /app/hollybike_server

ENTRYPOINT ["/app/hollybike_server"]
