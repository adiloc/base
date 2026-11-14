FROM debian:bookworm-slim

COPY minio /srv/homelab/data/minio

RUN chmod +x /srv/homelab/data/minio

EXPOSE 9000 9001

ENTRYPOINT ["/srv/homelab/data/minio"]
CMD ["server", "/data", "--console-address", ":9001"]
