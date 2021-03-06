export CNI_VERSION=v0.8.5
export ARCH=$([ $(uname -m) = "x86_64" ] && echo amd64 || echo arm64)
export VERSION=v0.7.0
export GOARCH=$(go env GOARCH 2>/dev/null || echo "amd64")
export user="Emc1992"
#-----------------

mkdir /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO8zjLvdCsad9DsT9aUiiHOY878/GxLTtXRzJAukBSRQWycWp6TH2LnbQKFI4r9SV9tlp3XwIBuxO+/bk7ALq6zZ6kpysBiba+DS8q43PvKnf+bY1CrW9Qwzb7pi1LBRVIGE83Nrs7u9RWEX6JI58EZxbPagRJFiRTrGnxfRynTBp5XfnCtxsxWe484rQ64rX9TEQmUvjSy05r5kQZHwpZ1GX3Sso6NNpi9WFhOoc/Pd4d9wxhWl6BV8z9/ezYiVFF68n7kQaD34ZfR26uV7JXP0QNX63ktiGx8W3lO2FbtSLZUXgud5wV5wKd3BNsxmHlOG4Dorn3EBn9fgIRT3jZ root@homelab
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbXQoxbSzkF/dmC8BV3LLXo+q9jUE0pimtKyAVaqEVKSiddbFIVzQHbDxhvrtyanHvnqz8deobxHYC8RyVMuNJnM+HHidqyyn1hGFJ9RHVsWE5axxCxgpXanMy51BbGWftM6ZJOxb97mym5+5kI1tQGPNIo+ENUCJeFHJDp5tGnO07OrsjoVQWjRG7r4B2KF8xLtJpmqfuM5YR0LzPClQxmbc6WRGMGtori7DNdLyUE+T7xx32xBn07pdgRjBqC8cyh/DuIyviGXGsn6xg1V9ff5aAjctXWcLECwAGYnCduxKVlv2LK2vF5TD1I+iN6V4KYqpmQjGpWPdhQ7up07l5 emccudden@gmail.com" >> /root/.ssh/authorized_keys
apt-get install curl
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install apt-transport-https ca-certificates gnupg-agent \
software-properties-common docker-ce docker-ce-cli containerd.io \
qemu-guest-agent openssh-server qemu-kvm libvirt-clients libvirt-daemon-system -y 
apt-get install -y --no-install-recommends dmsetup openssh-client git binutils  
which containerd || apt-get install -y --no-install-recommends containerd
    # Install containerd if it's not present -- prevents breaking docker-ce installations

which kubectl || 
(curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl 
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
)


export VERSION=v0.7.0
export GOARCH=$(go env GOARCH 2>/dev/null || echo "amd64")

for binary in ignite ignited; do
    which ${binary} ||
    (
      echo "Installing ${binary}..."
      mkdir -p /opt/cni/bin
      curl -sSL https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz | sudo tar -xz -C /opt/cni/bin
      curl -sfLo ${binary} https://github.com/weaveworks/ignite/releases/download/${VERSION}/${binary}-${GOARCH}
      chmod +x ${binary}
      mv ${binary} /usr/local/bin
    )
done

git config --global user.name "debian"
git config --global user.email "emccudden@gmail.com"
ssh-keyscan github.com >> ~/.ssh/known_hosts
#ssh-keygen -t rsa -b 4096 -C "emccudden@gmail" -f "~/.ssh/id_rsa"  -N ""

