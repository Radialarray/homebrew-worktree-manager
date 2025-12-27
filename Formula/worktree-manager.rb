class WorktreeManager < Formula
  desc "Fast, intuitive CLI for managing Git worktrees"
  homepage "https://github.com/Radialarray/worktree-manager"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.3/worktree-manager-aarch64-apple-darwin.tar.xz"
    sha256 "e2db35a4f295968931f127c851e6197031fad6ab0417a5d76acad99933d0b32d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.3/worktree-manager-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "10ed5450ab137578f2abc64c0e0a67dc5ddb38d891288d5142c66b42bea7c85e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.3/worktree-manager-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3963408282e80cb14b0748cc7d1d6a4f870d847b5b46094760794893658f3256"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "wt" if OS.mac? && Hardware::CPU.arm?
    bin.install "wt" if OS.linux? && Hardware::CPU.arm?
    bin.install "wt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
