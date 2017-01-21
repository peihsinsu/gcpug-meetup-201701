build:
	docker build -t peihsinsu/simpleweb .
push: build
	docker push peihsinsu/simpleweb
