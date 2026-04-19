# Documentation: https://docs.brew.sh/Cask-Cookbook
#                https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
cask "kitty-linux" do
  version "nightly"
  sha256 "b1d481f8effa10a8cf801099e78773bdb470df88c8b9df8aa53cfca83a9f35ea"

  url "https://github.com/kovidgoyal/kitty/releases/download/#{version}/kitty-#{version}-x86_64.txz"
  name "kitty-linux"
  desc "Kitty is a fast, feature-rich, GPU-based terminal emulator"
  homepage "https://github.com/kovidgoyal/kitty"

  # Documentation: https://docs.brew.sh/Brew-Livecheck
  livecheck do
    url "https://api.github.com/repos/kovidgoyal/kitty/releases/latest"
    strategy :json do |json|
      json["tag_name"]
    end
  end

  binary "kitty/bin/kitty"
  binary "kitty/bin/kitten"
  artifact "kitty/share/applications/kitty.desktop",
           target: "#{Dir.home}/.local/share/applications/kitty.desktop"
  artifact "kitty/share/icons/hicolor/scalable/apps/kitty.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/kitty.svg"

  # Documentation: https://docs.brew.sh/Cask-Cookbook#stanza-zap
  zap trash: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/kitty.svg"
end
