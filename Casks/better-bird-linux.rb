# Documentation: https://docs.brew.sh/Cask-Cookbook
#                https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
cask "better-bird-linux" do
  version "140.9.0esr-bb20"
  sha256 :no_check

  url "https://www.betterbird.eu/downloads/LinuxArchive/betterbird-#{version}.en-US.linux-x86_64.tar.xz"
  name "better-bird-linux"
  desc "Mail client"
  homepage "https://www.betterbird.eu/"

  livecheck do
    url "https://www.betterbird.eu/downloads/getloc.php?os=linux&lang=en-US&version=release"
    strategy :page_match
    regex(/href=.*?betterbird[._-]v?(\d+(?:\.\d+)+)\.en-US\.linux-x86_64\.tar\.xz/i)
  end

  auto_updates true

  binary "betterbird/betterbird"
  artifact(
    "betterbird/betterbird.desktop",
    target: "#{Dir.home}/.local/share/applications/betterbird.desktop",
  )
  artifact(
    "betterbird/chrome/icons/default/default128.png",
    target: "#{Dir.home}/.local/share/icons/betterbird.png",
  )

  preflight do
    FileUtils.mkdir_p("#{Dir.home}/.local/share/applications")
    File.write(
      "#{staged_path}/betterbird/betterbird.desktop",
      <<~EOS,
        [Desktop Entry]
        Name=BetterBird
        Keywords=internet,email,mail,web
        Exec=#{HOMEBREW_PREFIX}/bin/betterbird %u
        Icon=#{Dir.home}/.local/share/icons/betterbird.png
        Terminal=false
        Type=Application
        StartupWMClass=BetterBird
        Categories=Api;Code;Development;Text;Edit;Editor;
        Actions=new-empty-window;new-private-window;

      EOS
    )
  end

  zap(
    trash: [
      "~/.betterbird",
      "~/.config/betterbird",
    ],
  )
end
