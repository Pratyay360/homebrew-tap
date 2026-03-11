# Maintainer: zxp19821005 <zxp19821005 at 163 dot com>
require 'fileutils'

pkgname = "gopeed-bin"
pkgdisplay = "Gopeed"
pkgver = "1.9.2"
pkgrel = "1"
pkgdesc = "High speed downloader that supports all platforms.(Prebuilt version)"
arch = [
    'aarch64',
    'x86_64'
]
url = "https://gopeed.com/"
ghurl = "https://github.com/GopeedLab/gopeed"
license = ['GPL-3.0-only']
provides = ["#{pkgname.sub(/-bin$/, '')}-#{pkgver}"]
conflicts = ["#{pkgname.sub(/-bin$/, '')}"]
depends = [
    'gtk3',
    'libdbusmenu-glib',
    'libayatana-appindicator',
    'libayatana-indicator',
    'ayatana-ido',
    'libkeybinder3'
]
source = ["#{pkgname.sub(/-bin$/, '')}.sh"]
source_aarch64 = ["#{pkgname.sub(/-bin$/, '')}-#{pkgver}-aarch64.rpm::#{ghurl}/releases/download/v#{pkgver}/#{pkgname}-v#{pkgver}-linux-arm64.rpm"]
source_x86_64 = ["#{pkgname.sub(/-bin$/, '')}-#{pkgver}-x86_64.rpm::#{ghurl}/releases/download/v#{pkgver}/#{pkgname}-v#{pkgver}-linux-amd64.rpm"]
sha256sums = ['3b8311438e88f47eb507322a43c7a4156bfebb8c0f6e7b7436ef70842fb4c745']
sha256sums_aarch64 = ['3ecb73c33a5bcd3ee1728fa47394ab6bcece5482683715d37a2165c10a0e53ae']
sha256sums_x86_64 = ['279d11bfac29a2ed99eb3d062c63be2a479e64f5a1a0628c84119cfaf43975a9']

def prepare(pkgname, pkgdisplay, srcdir)
    system("sed", "-i", "-e", "
        s/@appname@/#{pkgname.sub(/-bin$/, '')}/g
        s/@runname@/#{pkgname.sub(/-bin$/, '')}/g
    ", "#{srcdir}/#{pkgname.sub(/-bin$/, '')}.sh")
    system("sed", "-i", "-e", "
        3i\\GenericName=#{pkgdisplay} Download Manager
        3i\\MimeType=x-scheme-handler\\/gopeed;x-scheme-handler\\/magnet;application\\/x-bittorrent;
        3i\\Categories=Network;Utility;
        3i\\Keywords=Application;DownloadManager;Network;Utility;
        3i\\StartupNotify=False
    ", "#{srcdir}/usr/share/applications/#{pkgname.sub(/-bin$/, '')}.desktop")
end

def package(pkgname, srcdir, pkgdir)
    system("install", "-Dm755", "#{srcdir}/#{pkgname.sub(/-bin$/, '')}.sh", "#{pkgdir}/usr/bin/#{pkgname.sub(/-bin$/, '')}")
    system("install", "-Dm755", "-d", "#{pkgdir}/usr/lib")
    FileUtils.cp_r("#{srcdir}/opt/#{pkgname.sub(/-bin$/, '')}", "#{pkgdir}/usr/lib")
    system("install", "-Dm644", "#{srcdir}/usr/share/icons/hicolor/scalable/apps/#{pkgname.sub(/-bin$/, '')}.svg",
        "-t", "#{pkgdir}/usr/share/icons/hicolor/scalable/apps")
    system("install", "-Dm644", "#{srcdir}/usr/share/applications/#{pkgname.sub(/-bin$/, '')}.desktop", "-t", "#{pkgdir}/usr/share/applications")
end
