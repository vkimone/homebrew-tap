class HomeTidy < Formula
  desc "Smart home folder cache cleanup tool for macOS"
  homepage "https://github.com/vkimone/home-tidy"
  url "https://github.com/vkimone/home-tidy/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "92e9303eeaf6694a7b4a73a9733c956e0b7e58e469da720d2d166a838f555699"
  license "MIT"
  version "0.1.0"

  def install
    # Install main script
    bin.install "home-tidy.sh" => "home-tidy"
    
    # Install libraries
    libexec.install "lib"
    
    # Install config templates
    (prefix/"config").install Dir["config/*"]
    
    # Update script to use correct paths
    inreplace bin/"home-tidy" do |s|
      s.gsub! 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
              "SCRIPT_DIR=\"#{libexec}\""
      s.gsub! 'CONFIG_DIR="${SCRIPT_DIR}/config"',
              "CONFIG_DIR=\"#{prefix}/config\""
      s.gsub! 'LIB_DIR="${SCRIPT_DIR}/lib"',
              "LIB_DIR=\"#{libexec}/lib\""
      # Version fix: Inject version directly into the script
      s.gsub! 'local version="unknown"',
              "local version=\"#{version}\""
    end
  end

  def caveats
    <<~EOS
      Configuration files are stored in:
        ~/Library/Application Support/home-tidy/config/

      The default templates are located at:
        #{prefix}/config/

      On first run, default configs will be automatically copied to your user directory.

      Run 'home-tidy --help' to see available options.
    EOS
  end

  test do
    system "#{bin}/home-tidy", "--help"
  end
end
