#!/bin/bash
set -xe


VERSION=0.1.0


deb_build_dir=_mkdeb
deb_ctl_dir=${deb_build_dir}/DEBIAN
deb_pgm_dir=${deb_build_dir}/usr/local/echo_service


rm -rf _mkdeb
mkdir -p ${deb_ctl_dir}
# mkdir -p ${deb_pgm_dir}
mkdir -p ${deb_pgm_dir}/bin


cp build/server ${deb_pgm_dir}/bin/
cp build/client ${deb_pgm_dir}/bin/
cp echo.service ${deb_pgm_dir}

SIZE=$(du -s ./_mkdeb | awk '{print $1}')


cat >${deb_ctl_dir}/postinst <<EOF
#!/bin/bash
# systemctl disable echo.service
systemctl enable /usr/local/echo_service/echo.service
exit 0
EOF
chmod 755 ${deb_ctl_dir}/postinst


cat >${deb_ctl_dir}/prerm <<EOF
#!/bin/bash
systemctl stop echo.service
systemctl disable echo.service
exit 0
EOF
chmod 755 ${deb_ctl_dir}/prerm




if [ $(uname -m)"XXX" == "x86_64XXX" ]; then
	arch=amd64
fi
if [ $(uname -m)"XXX" == "aarch64XXX" ]; then
	arch=arm64
fi

cat >${deb_ctl_dir}/control <<EOF
Package: echo-service
Priority: extra
Section: checkinstall
Installed-Size: ${SIZE}
Maintainer: zqy
Architecture: ${arch}
Version: ${VERSION}
Provides: echo_service
Description: example echo service
EOF
chmod 644 ${deb_ctl_dir}/control




# dpkg -b ${deb_build_dir} echo-service.${VERSION}_all.deb

dpkg -b ${deb_build_dir} .