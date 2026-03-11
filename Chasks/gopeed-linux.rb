# frozen_string_literal: true

require "fileutils"

PKGNAME = "gopeed-bin"
PKGDISPLAY = "Gopeed"
PKGVER = "1.9.2"
PKGREL = "1"
PKGDESC = "High speed downloader that supports all platforms.(Prebuilt version)"
ARCH = %w[aarch64 x86_64].freeze
URL = "https://gopeed.com/"
GHURL = "https://github.com/GopeedLab/gopeed"
LICENSE = %w[GPL-3.0-only].freeze
PROVIDES = ["#{PKGNAME.sub(/-bin$/, "")}-#{PKGVER}"].freeze
CONFLICTS = [PKGNAME.sub(/-bin$/, "")].freeze
DEPENDS = %w[
  gtk3
  libdbusmenu-glib
  libayatana-appindicator
  libayatana-indicator
  ayatana-ido
  libkeybinder3
].freeze
SOURCE = ["#{PKGNAME.sub(/-bin$/, "")}.sh"].freeze
SOURCE_AARCH64 = [
  "#{PKGNAME.sub(/-bin$/, "")}-#{PKGVER}-aarch64.rpm::" \
  "#{GHURL}/releases/download/v#{PKGVER}/#{PKGNAME}-v#{PKGVER}-linux-arm64.rpm",
].freeze
SOURCE_X86_64 = [
  "#{PKGNAME.sub(/-bin$/, "")}-#{PKGVER}-x86_64.rpm::" \
  "#{GHURL}/releases/download/v#{PKGVER}/#{PKGNAME}-v#{PKGVER}-linux-amd64.rpm",
].freeze
SHA256SUMS = ["3b8311438e88f47eb507322a43c7a4156bfebb8c0f6e7b7436ef70842fb4c745"].freeze
SHA256SUMS_AARCH64 = ["3ecb73c33a5bcd3ee1728fa47394ab6bcece5482683715d37a2165c10a0e53ae"].freeze
SHA256SUMS_X86_64 = ["279d11bfac29a2ed99eb3d062c63be2a479e64f5a1a0628c84119cfaf43975a9"].freeze

def prepare(srcdir)
  pkgname_short = PKGNAME.sub(/-bin$/, "")
  system("sed", "-i",
         "-e", "s/@appname@/#{pkgname_short}/g",
         "-e", "s/@runname@/#{pkgname_short}/g",
         "#{srcdir}/#{pkgname_short}.sh")
  system("sed", "-i",
         "-e", "3i\\GenericName=#{PKGDISPLAY} Download Manager",
         "-e", "3i\\MimeType=x-scheme-handler\\/gopeed;x-scheme-handler\\/magnet;application\\/x-bittorrent;",
         "-e", "3i\\Categories=Network;Utility;",
         "-e", "3i\\Keywords=Application;DownloadManager;Network;Utility;",
         "-e", "3i\\StartupNotify=False",
         "#{srcdir}/usr/share/applications/#{pkgname_short}.desktop")
end

def package(srcdir, pkgdir)
  pkgname_short = PKGNAME.sub(/-bin$/, "")
  system("install", "-Dm755",
         "#{srcdir}/#{pkgname_short}.sh",
         "#{pkgdir}/usr/bin/#{pkgname_short}")
  system("install", "-Dm755", "-d", "#{pkgdir}/usr/lib")
  FileUtils.cp_r("#{srcdir}/opt/#{pkgname_short}", "#{pkgdir}/usr/lib")
  system("install", "-Dm644",
         "#{srcdir}/usr/share/icons/hicolor/scalable/apps/#{pkgname_short}.svg",
         "-t", "#{pkgdir}/usr/share/icons/hicolor/scalable/apps")
  system("install", "-Dm644",
         "#{srcdir}/usr/share/applications/#{pkgname_short}.desktop",
         "-t", "#{pkgdir}/usr/share/applications")
end
