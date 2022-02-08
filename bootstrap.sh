#!/bin/bash
# Bootstrap machine

ensure_netplan_apply() {
    # First node up assign dhcp IP for eth1, not base on netplan yml
    sleep 5
    sudo netplan apply
}

step=1
step() {
    echo "Step $step $1"
    step=$((step+1))
}

resolve_dns() {
    step "===== Create symlink to /run/systemd/resolve/resolv.conf ====="
    sudo rm /etc/resolv.conf
    sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
}

set_hostname() {
    step "Setup hostname"
    sudo hostnamectl set-hostname carbonio # change this
    sudo echo "172.16.0.200 carbonio.casa.intra carbonio" >> /etc/host   # change this to your needs
}

install_dnsmasq(){
   step "Install DNSMasq"
   sudo apt update
   sudo apt-get -y install dnsmasq
   sudo su
   echo -e 'domain-needed\nserver=172.16.0.1\ndomain=casa.intra\nlocal=/casa.intra/\nmx-host=casa.intra,carbonio.casa.intra,0\naddress=/carbonio.casa.intra/172.16.0.200\n host-record=casa.intra,172.16.0.200\nhost-record=carbonio.casa.intra,172.16.0.200\n' > /etc/dnsmasq.conf # change this to your needs
  sudo systemctl disable systemd-resolved
  sudo systemctl stop systemd-resolved
  sudo systemctl enable dnsmasq
  sudo systemctl start dnsmasq
}

install_carbonio(){
  step "Install Install carbonio"
  sudo su
  echo 'deb https://repo.zextras.io/rc/ubuntu focal main' >>/etc/apt/sources.list.d/zextras.list
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 52FD40243E584A21
  sudo apt update
#  sudo apt-get -y upgrade
  sudo apt-get -y install carbonio-ce

}

final(){
  #test if mx can be resolved, is this previus step is fine, do the bootstrap and config carbonio, this took 5-10 min
  step "Now run carbonio-bootstrap"
}

main() {
    ensure_netplan_apply
    resolve_dns
    set_hostname
    install_dnsmasq
    install_carbonio
    final
}

main
