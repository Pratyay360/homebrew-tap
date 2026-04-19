cask "zen-linux" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.19.8b"
  sha256 arm64_linux:  "025ab27985bd7ef5494d729ea43ace45f737acaf1541d341402977dd318c21ad",
         x86_64_linux: "7bc0a2d0ff861530d68b8c399f66297ec05c5a6ee740757f8429ba161091ef89"

  url "https://github.com/zen-browser/desktop/releases/download/#{version}/zen.linux-#{arch}.tar.xz"
  name "Zen Browser"
  desc "Firefox-based browser focused on productivity and privacy"
  homepage "https://zen-browser.app/"


  livecheck do
    url "https://api.github.com/repos/zen-browser/desktop/releases/latest"
    strategy :json do |json|
      json["tag_name"]
    end
  end

  auto_updates true

  binary "zen/zen"
  artifact "zen/zen.desktop",
           target: "#{Dir.home}/.local/share/applications/zen.desktop"
  artifact "zen/browser/chrome/icons/default/default128.png",
           target: "#{Dir.home}/.local/share/icons/zen.png"

  preflight do
    FileUtils.mkdir_p "#{Dir.home}/.local/share/applications"
    FileUtils.mkdir_p "#{Dir.home}/.local/share/icons"

    File.write("#{staged_path}/zen/zen.desktop", <<~EOS)
      [Desktop Entry]
      Name=Zen Browser
      Comment=Experience tranquillity while browsing the web without people tracking you!
      Keywords=web;browser;internet
      Exec=#{HOMEBREW_PREFIX}/bin/zen %u
      Icon=#{Dir.home}/.local/share/icons/zen.png
      Terminal=false
      StartupNotify=true
      StartupWMClass=zen
      NoDisplay=false
      Type=Application
      MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
      Categories=Network;WebBrowser;
      Actions=new-window;new-blank-window;new-private-window;profile-manager-window;

      [Desktop Action new-window]
      Name=Open a New Window
      Exec=#{HOMEBREW_PREFIX}/bin/zen --new-window %u

      [Desktop Action new-blank-window]
      Name=Open a New Blank Window
      Exec=#{HOMEBREW_PREFIX}/bin/zen --blank-window %u

      [Desktop Action new-private-window]
      Name=Open a New Private Window
      Exec=#{HOMEBREW_PREFIX}/bin/zen --private-window %u

      [Desktop Action profile-manager-window]
      Name=Open the Profile Manager
      Exec=#{HOMEBREW_PREFIX}/bin/zen --ProfileManager
    EOS
  end

  zap trash: [
    "~/.config/zen",
    "~/.zen",
  ]
end
