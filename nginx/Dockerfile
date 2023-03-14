FROM nginx:alpine

# インクルード用のディレクトリ内を削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
COPY nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

COPY tmp/sockets /tmp/sockets

EXPOSE 80