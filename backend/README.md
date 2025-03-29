Dockerfileを使ってビルドして、デプロイする

# 開発環境
## ローカルでビルドする
```
docker compose -f docker-compose.dev.yml up --build
```

## ローカルで実行する
```
docker compose -f docker-compose.dev.yml up
```


# 本番環境
## ローカルでビルドする
```
docker compose -f docker-compose.prod.yml up --build
```

## ローカルで実行する
```
docker compose -f docker-compose.prod.yml up
```

## 本番用マルチステージビルド
```
docker buildx build --platform linux/arm64,linux/amd64 -f Dockerfile.prod -t shunkicreate/photoviewer-backend:latest --push .
```
