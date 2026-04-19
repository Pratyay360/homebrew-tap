# Documentation: https://docs.brew.sh/Cask-Cookbook
#                https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
cask "firefox-linux" do
  version "149.0.2"
  sha256 "814e872b969a4a33b6d44d27a2ab2f4b2c81692560cadb5855c0a3ae269e20e8"

  url "https://download-installer.cdn.mozilla.net/pub/firefox/releases/#{version}/linux-x86_64/en-US/firefox-#{version}.tar.xz"
  name "firefox-linux"
  desc "Web browser from Mozilla"
  homepage "https://www.mozilla.org/firefox/"

  livecheck do
    url "https://download-installer.cdn.mozilla.net/pub/firefox/releases/latest/"
    strategy :page_match
    regex(%r{href=.*?/linux-x86_64/en-US/firefox-(\d+(?:\.\d+)+)\.tar\.xz}i)
  end

  auto_updates true

  binary "firefox/firefox"
  artifact "firefox/firefox.desktop",
           target: "#{Dir.home}/.local/share/applications/firefox.desktop"
  artifact "firefox/browser/chrome/icons/default/default128.png",
           target: "#{Dir.home}/.local/share/icons/firefox.png"

  preflight do
    FileUtils.mkdir_p "#{Dir.home}/.local/share/applications"
    File.write("#{staged_path}/firefox/firefox.desktop", <<~EOS)
      [Desktop Entry]
      Name=Firefox
      Keywords=web,development,code,api,text,editor
      Exec=#{HOMEBREW_PREFIX}/bin/firefox %u
      Icon=#{Dir.home}/.local/share/icons/firefox.png
      Terminal=false
      Type=Application
      StartupWMClass=Firefox
      Categories=Api;Code;Development;Text;Edit;Editor;
      Actions=new-empty-window;new-private-window;

      [Desktop Action new-empty-window]
      Name=New Empty Window
      Exec=#{HOMEBREW_PREFIX}/bin/firefox --new-window %F
      Icon=#{Dir.home}/.local/share/icons/firefox.png

      [Desktop Action new-private-window]
      Name=New Private Window
      Exec=#{HOMEBREW_PREFIX}/bin/firefox --private-window %F
      Icon=#{Dir.home}/.local/share/icons/firefox.png
    EOS
  end

  zap trash: [
    "~/.config/firefox",
    "~/.mozilla",
  ]
end
