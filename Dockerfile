FROM nimlang/nim:2.0.2-alpine
#FROM nimlang/nim:devel

RUN apk add sqlite-dev

ENV PORT 8080
EXPOSE 8080

WORKDIR /a3

COPY . .

RUN nimble install -y

ENTRYPOINT [ "nim", "c", "-r", "src/a3.nim" ]