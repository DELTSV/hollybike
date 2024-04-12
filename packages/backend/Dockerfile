FROM debian:bookworm-slim as build-env

FROM alpine:3.14

COPY build/native/nativeCompile/hollybike-Linux-0.0.1-x86_64 /app/hollybike_server

COPY --from=build-env /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=build-env /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6

RUN chmod +x /app/hollybike_server

RUN apk add libc6-compat

RUN ls -la /app

ENTRYPOINT ["/bin/ash"]
