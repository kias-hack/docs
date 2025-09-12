sudo apt update
sudo apt upgrade
sudo apt install wget ncdu htop git openssh-client make pythpn3 pip python3.13-venv

wget https://go.dev/dl/go1.25.1.linux-amd64.tar.gz -O ~/go1.25.1.linux-amd64.tar.gz
sudo tar -xzf ~/go1.25.1.linux-amd64.tar.gz -C /usr/local
echo 'export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
' >> ~/.bashrc

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#echo -e "sudo dockerd &\n" >> /.bashrc

echo -e "{ "registry-mirrors" : [ "https://dockerhub.timeweb.cloud" ] }" >>  ~/.config/docker/daemon.json
