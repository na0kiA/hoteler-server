FROM nginx:alpine

# インクルード用のディレクトリ内を削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
COPY nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

# RUN mkdir -p app
# COPY tmp/sockets/puma.sock /app/sockets/puma.sock
# COPY ./public /app/public
# COPY ./tmp/sockets /app/tmp/sockets
# VOLUME /app/public
# VOLUME /app/tmp

EXPOSE 80