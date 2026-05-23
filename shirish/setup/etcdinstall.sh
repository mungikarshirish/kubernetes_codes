ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ARCH_TYPE="amd64"
elif [ "$ARCH" = "aarch64" ]; then
    ARCH_TYPE="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

ETCD_VER=v3.6.7
DOWNLOAD_URL=https://storage.googleapis.com/etcd
DOWNLOAD_FILE=etcd-${ETCD_VER}-linux-${ARCH_TYPE}.tar.gz

mkdir -p /tmp/etcd-download
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/${DOWNLOAD_FILE} -o /tmp/${DOWNLOAD_FILE}

tar xzvf /tmp/${DOWNLOAD_FILE} -C /tmp/etcd-download --strip-components=1

sudo mv /tmp/etcd-download/etcd /tmp/etcd-download/etcdctl /tmp/etcd-download/etcdutl /usr/local/bin/
rm -f /tmp/${DOWNLOAD_FILE}
rm -rf /tmp/etcd-download