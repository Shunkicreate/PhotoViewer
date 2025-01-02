# k8sの起動方法
## k8sのシークレットの登録の仕方

以下のコマンドを使用して、k8sのシークレットを登録します:

```sh
kubectl create secret generic front-env-secret --from-env-file=front/.env
kubectl create secret generic backend-env-secret --from-env-file=backend/.env
```

## デプロイ方法

以下のコマンドを実行してデプロイします:

```sh
make deploy
```

## 確認方法

1. `kubectl get pods -A` で Pod が起動しているか確認します。
2. フロントエンドにアクセスするには、NodePort を使用します: `http://<Pi IP>:30174/`
3. フロントエンドが内部で `http://photoviewer-backend-svc:8080` を呼べるか確認します。
4. HPAの状態を確認するには、`kubectl get hpa` を実行し、READY または Scaled 状態を確認します。

## k3sのインストール方法
```
# Install k3s
sudo curl -sfL https://get.k3s.io | sh -
# Check the status
sudo systemctl status k3s
``` 
