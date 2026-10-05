# Documentation: https://docs.brew.sh/Cask-Cookbook
#                https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
cask "wezterm-linux" do
  version "20240203-110809-5046fc22"
  sha256 :no_check

  url "https://github.com/wezterm/wezterm/releases/download/#{version}/WezTerm-#{version}-Ubuntu20.04.AppImage"
  name "wezterm-linux"
  desc "WezTerm Terminal for Linux"
  homepage "https://wezterm.org/"

  # Documentation: https://docs.brew.sh/Brew-Livecheck
  livecheck do
    url "https://api.github.com/repos/wezterm/wezterm/releases/latest"
    strategy :json do |json|
      json["tag_name"]
    end
  end

  binary "WezTerm-#{version}-Ubuntu20.04.AppImage", target: "wezterm"
  artifact "wezterm.desktop", target: "#{Dir.home}/.local/share/applications/wezterm.desktop"
  artifact "org.wezfurlong.wezterm.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/org.wezfurlong.wezterm.png"

  preflight_steps do
    mkdir_p ".local/share/applications", base: :home
    mkdir_p ".local/share/icons/hicolor/512x512/apps", base: :home
    set_permissions "WezTerm-#{version}-Ubuntu20.04.AppImage", "+x", recursive: false
    run "WezTerm-#{version}-Ubuntu20.04.AppImage", base: :staged_path,
        args: ["--appimage-extract"], chdir: ".", writable_paths: ["."]
    if_path_exists "squashfs-root/org.wezfurlong.wezterm.png" do
      copy "squashfs-root/org.wezfurlong.wezterm.png", "org.wezfurlong.wezterm.png"
    end
    write_file(
      "wezterm.desktop",
      <<~EOS,
        [Desktop Entry]
        Name=WezTerm
        Comment=AI-first coding environment
        GenericName=Terminal
        Exec={{HOMEBREW_PREFIX}}/bin/wezterm %F
        Icon=org.wezfurlong.wezterm
        Type=Application
        StartupNotify=false
        StartupWMClass=WezTerm
        Categories=TextEditor;Development;IDE;
        MimeType=text/plain;inode/directory;application/x-code-workspace;
        Actions=new-empty-window;
        Keywords=wezterm;code;editor;
        [Desktop Action new-empty-window]
        Name=New Empty Window
        Exec={{HOMEBREW_PREFIX}}/bin/wezterm --new-window %F
        Icon=org.wezfurlong.wezterm
      EOS
    )
    # Create a placeholder icon if extraction fails
    unless_path_exists "org.wezfurlong.wezterm.png" do
      touch "org.wezfurlong.wezterm.png"
    end
  end

  zap(
    trash: [
      "~/.config/wezterm",
      "~/.wezterm",
    ],
  )
end
