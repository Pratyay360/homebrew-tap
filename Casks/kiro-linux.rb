cask "kiro-linux" do
  version "0.11.131"
  sha256 "fdf8a141163eb2b6ed01ae95f925d63e48124cb3ba7015cc4c5a15b0caa83710"

  url "https://prod.download.desktop.kiro.dev/releases/stable/linux-x64/signed/#{version}/tar/kiro-ide-#{version}-stable-linux-x64.tar.gz"
  name "Kiro-linux"
  desc "Amazon kiro ide"
  homepage "https://kiro.dev/"

  livecheck do
    url "https://prod.download.desktop.kiro.dev/stable/metadata-linux-x64-stable.json"
    strategy :json do |json|
      json["currentRelease"]
    end
  end

  binary "Kiro/bin/kiro"
  bash_completion "#{staged_path}/Kiro/resources/completions/bash/kiro"
  zsh_completion  "#{staged_path}/Kiro/resources/completions/zsh/_kiro"
  artifact "Kiro/kiro.desktop",
           target: "#{Dir.home}/.local/share/applications/kiro.desktop"
  artifact "Kiro/resources/app/resources/linux/code.png",
           target: "#{Dir.home}/.local/share/icons/kiro.png"

  preflight do
    FileUtils.mkdir_p "#{Dir.home}/.local/share/applications"
    File.write("#{staged_path}/Kiro/kiro.desktop", <<~EOS)
      [Desktop Entry]
      Name=Kiro
      Keywords=web,development,code,api,text,editor
      Exec=#{HOMEBREW_PREFIX}/bin/kiro %u
      Icon=#{Dir.home}/.local/share/icons/kiro.png
      Terminal=false
      Type=Application
      StartupWMClass=Kiro
      Categories=Api;Code;Development;Text;Edit;Editor;
      Actions=new-empty-window;

      [Desktop Action new-empty-window]
      Name=New Empty Window
      Exec=#{HOMEBREW_PREFIX}/bin/kiro --new-window %F
      Icon=#{Dir.home}/.local/share/icons/kiro.png
    EOS
  end

  zap trash: [
    "~/.config/Kiro",
    "~/.kiro",
  ]
end
