FROM golang:1.16.4-alpine AS builder
RUN mkdir /build
ADD . /build/
WORKDIR /build
RUN go build

FROM alpine
RUN adduser -S -D -H -h /app appuser
USER appuser
COPY --from=builder /build/moomin /app/
WORKDIR /app
# Expose port 5000 to the outside world
EXPOSE 5000
CMD ["./moomin"]