# Documentation: https://docs.brew.sh/Cask-Cookbook
#                https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
cask "helium-linux" do
  version "0.11.3.2"
  sha256 "0cc832d4d1f6fa1bb30c6c92942a8da608fb2672ede0eb6051e0a3c4c096bc5b"

  url "https://github.com/imputnet/helium-linux/releases/download/#{version}/helium-#{version}-x86_64_linux.tar.xz"
  name "helium-linux"
  desc "The Chromium-based web browser made for people"
  homepage "https://helium.computer"

  # Documentation: https://docs.brew.sh/Brew-Livecheck
  livecheck do
    url "https://api.github.com/repos/imputnet/helium-linux/releases/latest"
    strategy :json do |json|
      json["tag_name"]
    end
  end

  binary "helium-#{version}-x86_64_linux/helium"
  artifact "helium/share/applications/helium.desktop",
           target: "#{Dir.home}/.local/share/applications/helium.desktop"
  artifact "helium/product_logo_256.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/helium.png"

  preflight do
    FileUtils.mkdir_p "#{Dir.home}/.local/share/applications"
    File.write("#{staged_path}/helium.app/share/applications/helium.desktop", <<~EOS)
      [Desktop Entry]
      Name=Helium
      Keywords=web,development,code,api,text,editor
      Exec=#{HOMEBREW_PREFIX}/bin/helium %u
      Icon=#{staged_path}/helium/helium.png
      Terminal=false
      Type=Application
      StartupWMClass=Helium
      Categories=Api;Code;Development;Text;Edit;Editor;
      Actions=new-empty-window;

      [Desktop Action new-empty-window]
      Name=New Empty Window
      Exec=#{HOMEBREW_PREFIX}/bin/helium --new-window %F
      Icon=#{staged_path}/helium/helium.png
    EOS
  end

  # Documentation: https://docs.brew.sh/Cask-Cookbook#stanza-zap
  zap trash: "#{Dir.home}/.local/share/applications/helium.desktop"
end
