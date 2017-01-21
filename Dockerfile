From node

ADD ./web /app
WORKDIR /app

CMD ["npm","start"]
