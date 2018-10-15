#!/bin/bash
#卸载已经安装的，比较老的docker版本
sudo yum -y remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine
                  
#安装一些必要的依赖                  
sudo yum -y install -y yum-utils device-mapper-persistent-data lvm2

#替换阿里的docker源，加快安装速度
sudo yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#$ sudo yum-config-manager \
#    --add-repo \
#    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum makecache fast
sudo yum -y install docker-ce

sudo systemctl start docker.service
sudo systemctl enable docker.service

userName='whoami'
sudo groupadd docker
sudo usermod -aG docker $userName
sudo systemctl restart docker

#Install nvidia-docker and nvidia-docker-plugin
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo yum remove nvidia-docker

# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | \
  sudo tee /etc/yum.repos.d/nvidia-docker.repo

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo yum install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
#docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi

echo "Nvidia-docker Install successful."
sudo nvidia-docker --version

