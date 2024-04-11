FROM gcr.io/distroless/base
ARG EXECUTABLE
RUN test -n "$EXECUTABLE"
EXPOSE 8080
COPY build/native/nativeCompile/$EXECUTABLE /app
ENTRYPOINT ["/app"]