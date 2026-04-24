# Documentation: https://docs.brew.sh/Cask-Cookbook
#                https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
cask "wezterm-linux" do
  version "20240203-110809"
  sha256 :no_check

  url "https://github.com/wezterm/wezterm/releases/download/#{version}-5046fc22/WezTerm-#{version}-5046fc22-Ubuntu20.04.AppImage"
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

  binary "WezTerm-#{version}-5046fc22-Ubuntu20.04.AppImage", target: "wezterm"
  artifact "wezterm.desktop", target: "#{Dir.home}/.local/share/applications/wezterm.desktop"
  artifact "org.wezfurlong.wezterm.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/org.wezfurlong.wezterm.png"

  preflight do
    FileUtils.mkdir_p("#{Dir.home}/.local/share/applications")
    FileUtils.mkdir_p("#{Dir.home}/.local/share/icons/hicolor/512x512/apps")
    # Make AppImage executable
    appimage_name = "WezTerm-#{version}-5046fc22-Ubuntu20.04.AppImage"
    FileUtils.chmod("+x", "#{staged_path}/#{appimage_name}")
    system("#{staged_path}/#{appimage_name}", "--appimage-extract", chdir: staged_path)
    icon_source = "#{staged_path}/squashfs-root/org.wezfurlong.wezterm.png"
    FileUtils.cp(icon_source, "#{staged_path}/org.wezfurlong.wezterm.png") if File.exist?(icon_source)
    File.write(
      "#{staged_path}/wezterm.desktop",
      <<~EOS,
        [Desktop Entry]
        Name=WezTerm
        Comment=AI-first coding environment
        GenericName=Terminal
        Exec=#{HOMEBREW_PREFIX}/bin/wezterm %F
        Icon=#{Dir.home}/.local/share/icons/hicolor/512x512/apps/org.wezfurlong.wezterm.png
        Type=Application
        StartupNotify=false
        StartupWMClass=WezTerm
        Categories=TextEditor;Development;IDE;
        MimeType=text/plain;inode/directory;application/x-code-workspace;
        Actions=new-empty-window;
        Keywords=wezterm;code;editor;
        [Desktop Action new-empty-window]
        Name=New Empty Window
        Exec=#{HOMEBREW_PREFIX}/bin/wezterm --new-window %F
        Icon=#{Dir.home}/.local/share/icons/hicolor/512x512/apps/org.wezfurlong.wezterm.png
      EOS
    )
    # Create a placeholder icon if extraction fails
    unless File.exist?("#{staged_path}/org.wezfurlong.wezterm.png")
      FileUtils.touch("#{staged_path}/org.wezfurlong.wezterm.png")
    end
  end

  zap(
    trash: [
      "~/.config/wezterm",
      "~/.wezterm",
    ],
  )
end
