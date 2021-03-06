#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

[ "$EUID" -ne '0' ] && echo "Error,This script must be run as root! " && exit 1
apt install linux-image-3.13.0-24-generic

KernelList="$(dpkg -l |grep 'linux-image' |awk '{print $2}')"
[ -z "$(echo $KernelList |grep -o linux-image-3.13.0-24-generic)" ] && echo "Install error." && exit 1
for KernelTMP in `echo "$KernelList"`
 do
  [ "$KernelTMP" != "linux-image-3.13.0-24-generic" ] && echo -ne "Uninstall Old Kernel\n\t$KernelTMP\n" && apt-get purge "$KernelTMP" -y >/dev/null 2>&1
done

apt purge linux-headers* -y
apt install linux-headers-3.13.0-24-generic linux-image-extra-3.13.0-24-generic linux-tools-3.13.0-24-generic -y

apt-mark hold linux-image-3.13.0-24-generic

update-grub && update-grub2

echo
read -p "Info: The system needs to be restart. Do you want to reboot? [y/n]" is_reboot
if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
    reboot
else
    exit
fi
