class Bloop < Formula
  desc "Bloop gives you fast edit/compile/test workflows for Scala."
  homepage "https://github.com/scalacenter/bloop"
  version "1.1.1"
  url "https://github.com/scalacenter/bloop/releases/download/v1.1.1/install.py"
  sha256 "f40bd23e0059f3a82fb322d0e287b6d4eeede98178839afcb02027d8cd9de5d4"
  bottle :unneeded

  depends_on "python3"
  depends_on :java => "1.8+"

  def install
      mkdir "bin"
      system "python3", "install.py", "--dest", "bin", "--version", version
      zsh_completion.install "bin/zsh/_bloop"
      bash_completion.install "bin/bash/bloop"
      fish_completion.install "bin/fish/bloop.fish"

      # We need to create these files manually here, because otherwise launchd
      # will create them with owner set to `root` (see the plist file below).
      FileUtils.mkdir_p("log/bloop/")
      FileUtils.touch("log/bloop/bloop.out.log")
      FileUtils.touch("log/bloop/bloop.err.log")

      prefix.install "bin"
      prefix.install "log"
  end

  def plist; <<~EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{bin}/blp-server</string>
    </array>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>#{prefix}/log/bloop/bloop.out.log</string>
    <key>StandardErrorPath</key>
    <string>#{prefix}/log/bloop/bloop.err.log</string>
</dict>
</plist>
          EOS
      end

  test do
  end
end