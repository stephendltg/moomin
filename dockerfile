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


# FROM golang:rc

# # Set the Current Working Directory inside the container
# WORKDIR /app

# RUN export GO111MODULE=on

# # Copy go mod and sum files
# COPY go.mod go.sum ./

# # Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
# RUN go mod download

# COPY . . 

# # Build the application
# RUN go build -o main .

# # Expose port 5000 to the outside world
# EXPOSE 5000

# # Command to run the executable
# CMD ["./main"]