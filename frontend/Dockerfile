# =========================
# Stage 1: builder
# =========================
FROM node:22-alpine AS builder

# 作業ディレクトリ設定
WORKDIR /app

# 依存関係インストール用に package*.json をコピー
COPY package*.json ./

# devDependencies も含めてインストール（ビルドに必要なため）
RUN npm install

# ソースコード一式をコピー
COPY . .

# Remix のビルド（本番用バンドルを作成）
RUN npm run build

# =========================
# Stage 2: runner (本番運用用)
# =========================
FROM node:22-alpine AS runner

# 作業ディレクトリ設定
WORKDIR /app

# package*.json をコピーして、本番用依存関係のみインストール
COPY package*.json ./
RUN npm ci --production

# builder で生成した build/ ディレクトリ等、実行に必要な成果物だけコピー
COPY --from=builder /app/build      /app/build
COPY --from=builder /app/public     /app/public
# ↑ Remix の output (build/ や public/) を適宜コピー
#   public フォルダが存在する場合は一緒にコピーするケースが多いです

# ポート公開
EXPOSE 5174

# 本番起動コマンド（Remix App Server想定）
CMD ["npm", "run", "start"]
