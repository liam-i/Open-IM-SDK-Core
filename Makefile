.PHONY: ios build install android

BINARY_NAME=ws_wrapper/cmd/open_im_sdk_server
BIN_DIR=../../bin/
LAN_FILE=.go
GO_FILE:=${BINARY_NAME}${LAN_FILE}

build:
	CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -o ${BINARY_NAME}  ${GO_FILE}
install:
	make build
	mv ${BINARY_NAME} ${BIN_DIR}
clean:
	env GO111MODULE=on go clean -cache
	gomobile clean
	rm -fr build

reset_remote_branch:
	remote_branch=$(shell git rev-parse --abbrev-ref --symbolic-full-name @{u})
	git reset --hard $(remote_branch)
	git pull $(remote_branch)

ios:
	go get golang.org/x/mobile
	go mod download golang.org/x/exp
	GOARCH=arm64 gomobile bind -v -trimpath -ldflags "-s -w" -o build/OpenIMCore.xcframework -target=ios ./open_im_sdk/ ./open_im_sdk_callback/	
#注：windows下打包成aar，保证gomobile,android studio以及NDK安装成功，NDK版本在window上官方测试为r20b,然后可以使用类似下面的命令生成aar
#   mac下打包成aar,保证gomobile,android studio以及NDK安装成功,NDK版本官方测试为20.0.5594570，使用如下命令生成aar
android:
	go get golang.org/x/mobile
    GOARCH=amd64 gomobile bind -v -trimpath -ldflags="-s -w" -o ./open_im_sdk.aar -target=android ./open_im_sdk/ ./open_im_sdk_callback/
