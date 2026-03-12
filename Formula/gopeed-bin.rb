class GopeedBin < Formula
  desc "High speed downloader that supports all platforms (Prebuilt version)"
  homepage "https://gopeed.com/"
  version "1.9.2"
  license "GPL-3.0-only"

  # Mapping: arch=(aarch64 x86_64)
  if Hardware::CPU.intel?
    url "https://github.com/GopeedLab/gopeed/releases/download/v#{version}/Gopeed-v#{version}-linux-amd64.rpm"
    sha256 "279d11bfac29a2ed99eb3d062c63be2a479e64f5a1a0628c84119cfaf43975a9"
  else
    url "https://github.com/GopeedLab/gopeed/releases/download/v#{version}/Gopeed-v#{version}-linux-arm64.rpm"
    sha256 "3ecb73c33a5bcd3ee1728fa47394ab6bcece5482683715d37a2165c10a0e53ae"
  end

  # Mapping: depends=(...)
  depends_on "gtk+3"
  depends_on "dbus-glib"
  depends_on "libkeyfinder"
  depends_on "libayatana-appindicator"
  depends_on "rpm2cpio" => :build
  depends_on "libarchive" => :build # provides cpio

  def install
    # --- PREPARE PHASE ---
    # Extract the RPM manually (similar to how Arch handles sources)
    system "rpm2cpio #{cached_download} | cpio -idmv"

    # Mimicking your first 'sed' block for the launcher script
    # We create the .sh file directly here to avoid external source issues
    (buildpath/"gopeed.sh").write <<~EOS
      #!/bin/bash
      # Launcher for gopeed
      exec "#{libexec}/gopeed" "$@"
    EOS

    # Mimicking your second 'sed' block for the desktop file
    desktop_file = buildpath/"usr/share/applications/gopeed.desktop"

    if desktop_file.exist?
      inreplace desktop_file do |s|
        s.sub!("[Desktop Entry]\n", "[Desktop Entry]\n" \
          "GenericName=Gopeed Download Manager\n" \
          "MimeType=x-scheme-handler/gopeed;x-scheme-handler/magnet;application/x-bittorrent;\n" \
          "Categories=Network;Utility;\n" \
          "Keywords=Application;DownloadManager;Network;Utility;\n" \
          "StartupNotify=False\n")
      end
    end

    # --- PACKAGE PHASE ---
    # install -Dm755 gopeed.sh -> /usr/bin/gopeed
    bin.install "gopeed.sh" => "gopeed"

    # cp -Pr opt/gopeed -> /usr/lib/gopeed (Using libexec for Homebrew)
    libexec.install Dir["opt/gopeed/*"]

    # install icons and desktop files
    (share/"icons/hicolor/scalable/apps").install "usr/share/icons/hicolor/scalable/apps/gopeed.svg"
    (share/"applications").install "usr/share/applications/gopeed.desktop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopeed --version")
  end
end
