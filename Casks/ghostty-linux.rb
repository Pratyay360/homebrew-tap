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
      json["tag_name"].delete_prefix("v")
    end
  end

  binary "Ghostty-#{version}-x86_64.AppImage", target: "ghostty"
  artifact "com.mitchellh.ghostty.desktop",
           target: "#{Dir.home}/.local/share/applications/com.mitchellh.ghostty.desktop"
  artifact "com.mitchellh.ghostty.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/com.mitchellh.ghostty.png"

  preflight_steps do
    mkdir_p ".local/share/applications", base: :home
    mkdir_p ".local/share/icons/hicolor/512x512/apps", base: :home

    set_permissions "Ghostty-#{version}-x86_64.AppImage", "+x", recursive: false
    run "Ghostty-#{version}-x86_64.AppImage", base: :staged_path,
        args: ["--appimage-extract"], chdir: ".", writable_paths: ["."]
    if_path_exists "squashfs-root/com.mitchellh.ghostty.png" do
      copy "squashfs-root/com.mitchellh.ghostty.png", "com.mitchellh.ghostty.png"
    end
    write_file(
      "com.mitchellh.ghostty.desktop",
      <<~EOS,
        [Desktop Entry]
        Name=Ghostty
        Comment=AI-first coding environment
        GenericName=Terminal
        Exec={{HOMEBREW_PREFIX}}/bin/ghostty %F
        Icon=com.mitchellh.ghostty
        Type=Application
        StartupNotify=false
        StartupWMClass=Ghostty
        Categories=Terminal;code;
        MimeType=text/plain;inode/directory;application/x-code-workspace;
        Keywords=ghostty;code;editor;
        [Desktop Action new-empty-window]
        Name=New Empty Window
        Exec={{HOMEBREW_PREFIX}}/bin/ghostty --new-window %F
        Icon=com.mitchellh.ghostty
      EOS
    )
    # Create a placeholder icon if extraction fails
    unless_path_exists "com.mitchellh.ghostty.png" do
      touch "com.mitchellh.ghostty.png"
    end
  end

  zap(
    trash: [
      "~/.config/ghostty",
      "~/.ghostty",
    ],
  )
end
