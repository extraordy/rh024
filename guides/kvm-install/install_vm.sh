#!/bin/sh

KVMSTORAGEPOOL="default"
KVMNETWORK="default"
MYPWD=$PWD
MYPATH="/tmp"
MYTAR="rh024.tar.gz"
MYCLOUDID="1Vs_yrJzBbsgKzMKXtOPK3thvFptKJhBo"

checkexit() {
  if [ $? -ne 0 ]
  then
    >&2 echo "ERRORE: $1"
    cd
    exit 1
  fi
}

if [ "$EUID" -ne 0 ]; then
    >&2 echo "Per favore esegui questo script da root oppure con sudo:"
    >&2 echo "./$(basename $0)"
  exit
fi

wget -q --show-progress --load-cookies ${MYPATH}/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ${MYPATH}/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id='${MYCLOUDID} -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=${MYCLOUDID}" -O ${MYPWD}/${MYTAR} && rm -rf ${MYPATH}/cookies.txt

checkexit "Impossibile scaricare il file"

source /etc/os-release

GRP_INSTALL="virt"

if [ "$ID" = "fedora" ]; then
    GRP_INSTALL="virtualization"
fi

yum install -y @"$GRP_INSTALL" virt-install virt-viewer virt-v2v

checkexit "Impossibile installare i pacchetti di virtualizzazione"

pushd ${MYPATH} > /dev/null 2>&1

tar xzvf ${MYPWD}/${MYTAR}

checkexit "Impossibile aprire l'archivio"

if ! (virsh pool-info ${KVMSTORAGEPOOL} &> /dev/null); then
  mkdir -p /var/lib/libvirt/images
  virsh pool-define-as --name ${KVMSTORAGEPOOL} --type dir --target /var/lib/libvirt/images
  virsh pool-start ${KVMSTORAGEPOOL}
  virsh pool-autostart ${KVMSTORAGEPOOL}
fi

popd > /dev/null 2>&1

virt-v2v -i libvirtxml -o libvirt -os ${KVMSTORAGEPOOL} -n ${KVMNETWORK} ${MYPATH}/rh024.xml

checkexit "Impossibile importare la VM"

rm -f ${MYPATH}/RH024*.qcow2 ${MYPATH}/rh024.xml ${MYPWD}/${MYTAR}

checkexit "Impossibile cancellare i file temporanei"
