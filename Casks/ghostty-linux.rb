# Documentation: https://docs.brew.sh/Cask-Cookbook
#                https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
cask "ghostty-linux" do
  version "1.3.1"
  sha256 :no_check

  url "https://github.com/pkgforge-dev/ghostty-appimage/releases/download/v#{version}/Ghostty-#{version}-x86_64.AppImage"
  name "ghostty-linux"
  desc "Ghostty Terminal for Linux"
  homepage "https://ghostty.org/"

  # Documentation: https://docs.brew.sh/Brew-Livecheck
  livecheck do
    url "https://api.github.com/repos/pkgforge-dev/ghostty-appimage/releases/latest"
    strategy :json do |json|
      json["tag_name"]
    end
  end

  binary "Ghostty-#{version}-x86_64.AppImage", target: "ghostty"
  artifact "com.mitchellh.ghostty.desktop",
           target: "#{Dir.home}/.local/share/applications/com.mitchellh.ghostty.desktop"
  artifact "com.mitchellh.ghostty.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/com.mitchellh.ghostty.png"

  preflight do
    FileUtils.mkdir_p("#{Dir.home}/.local/share/applications")
    FileUtils.mkdir_p("#{Dir.home}/.local/share/icons/hicolor/512x512/apps")

    appimage_name = "Ghostty-#{version}-x86_64.AppImage"
    FileUtils.chmod("+x", "#{staged_path}/#{appimage_name}")
    system("#{staged_path}/#{appimage_name}", "--appimage-extract", chdir: staged_path)
    icon_source = "#{staged_path}/squashfs-root/com.mitchellh.ghostty.png"
    FileUtils.cp(icon_source, "#{staged_path}/com.mitchellh.ghostty.png") if File.exist?(icon_source)
    File.write(
      "#{staged_path}/com.mitchellh.ghostty.desktop",
      <<~EOS,
        [Desktop Entry]
        Name=Ghostty
        Comment=AI-first coding environment
        GenericName=Terminal
        Exec=#{HOMEBREW_PREFIX}/bin/ghostty %F
        Icon=#{Dir.home}/.local/share/icons/hicolor/512x512/apps/com.mitchellh.ghostty.png
        Type=Application
        StartupNotify=false
        StartupWMClass=Ghostty
        Categories=Terminal;code;
        MimeType=text/plain;inode/directory;application/x-code-workspace;
        Keywords=ghostty;code;editor;
        [Desktop Action new-empty-window]
        Name=New Empty Window
        Exec=#{HOMEBREW_PREFIX}/bin/ghostty --new-window %F
        Icon=#{Dir.home}/.local/share/icons/hicolor/512x512/apps/com.mitchellh.ghostty.png
      EOS
    )
    # Create a placeholder icon if extraction fails
    unless File.exist?("#{staged_path}/com.mitchellh.ghostty.png")
      FileUtils.touch("#{staged_path}/com.mitchellh.ghostty.png")
    end
  end

  zap(
    trash: [
      "~/.config/ghostty",
      "~/.ghostty",
    ],
  )
end
