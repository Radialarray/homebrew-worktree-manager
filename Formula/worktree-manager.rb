class WorktreeManager < Formula
  desc "Fast, intuitive CLI for managing Git worktrees"
  homepage "https://github.com/Radialarray/worktree-manager"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.5/worktree-manager-aarch64-apple-darwin.tar.xz"
      sha256 "b52520bfc94a24cf4e3400e8328c943cebab3a4da786e30dd88aa14000c6053f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.5/worktree-manager-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1649b7a94a2f744253ec4b4d7bd3e9576b71354ed05489298168fcb59fc25a48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.5/worktree-manager-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "72275e38f25e16f9e0b40e26545a66db086d1f484bd8ea84a27576578ceea047"
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
