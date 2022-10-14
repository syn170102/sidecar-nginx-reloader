FROM golang:1.12.0 as build
#RUN go env  GO111MODULE=auto
#RUN go env  GOPROXY=https://goproxy.cn
RUN go get github.com/fsnotify/fsnotify
RUN go get github.com/shirou/gopsutil/process
RUN mkdir -p /go/src/app
ADD main.go /go/src/app/
WORKDIR /go/src/app
RUN CGO_ENABLED=0 GOOS=linux go build -a -o nginx-reloader .
# main image
FROM 10.11.20.82/kubernetes/nginx:1.22.0
COPY --from=build /go/src/app/nginx-reloader /
CMD ["/nginx-reloader"]
