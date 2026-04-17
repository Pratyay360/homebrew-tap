cask "gram-linux" do
  version "1.2.1"
  sha256 "28d1623a32c8d99fe494754eb1aa7b34d66904e79bc19a7fa2ec772c3abaf45f"

  url "https://codeberg.org/GramEditor/gram/releases/download/#{version}/gram-linux-x86_64-#{version}.tar.gz"
  name "Gram"
  desc "Code editor for humanoid apes and grumpy toads"
  homepage "https://codeberg.org/GramEditor/gram"

  # Documentation: https://docs.brew.sh/Brew-Livecheck
  livecheck do
    url "https://codeberg.org/api/v1/repos/GramEditor/gram/releases/latest"
    strategy :json do |json|
      json["tag_name"]
    end
  end

  binary "gram.app/bin/gram"
  artifact "gram.app/share/applications/gram.desktop",
           target: "#{Dir.home}/.local/share/applications/app.liten.Gram.desktop"

  preflight do
    FileUtils.mkdir_p "#{Dir.home}/.local/share/applications"
    File.write("#{staged_path}/gram.app/share/applications/gram.desktop", <<~EOS)
      [Desktop Entry]
      Name=Gram
      Keywords=web,development,code,api,text,editor
      Exec=#{HOMEBREW_PREFIX}/bin/gram %u
      Icon=#{staged_path}/gram.app/share/icons/hicolor/scalable/apps/app.liten.Gram.svg
      Terminal=false
      Type=Application
      StartupWMClass=Gram
      Categories=Api;Code;Development;Text;Edit;Editor;
      Actions=new-empty-window;

      [Desktop Action new-empty-window]
      Name=New Empty Window
      Exec=#{HOMEBREW_PREFIX}/bin/gram --new-window %F
      Icon=#{staged_path}/gram.app/share/icons/hicolor/scalable/apps/app.liten.Gram.svg
    EOS
  end

  # Documentation: https://docs.brew.sh/Cask-Cookbook#stanza-zap
  zap trash: "#{Dir.home}/.local/share/applications/app.liten.Gram.desktop"
end
