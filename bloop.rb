class Bloop < Formula
  desc "Bloop is a build server to compile, test and run Scala fast"
  homepage "https://github.com/scalacenter/bloop"
  version "1.3.4"
  url "https://github.com/scalacenter/bloop/releases/download/v1.3.4/install.py"
  sha256 "4e95818e3c8815a1744b60c9aa63797d88602a5e8196cb84243b3f681cb4051d"
  bottle :unneeded

  depends_on "bash-completion"
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
        <string>#{bin}/bloop</string>
        <string>server</string>
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