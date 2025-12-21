class WorktreeManager < Formula
  desc "Fast, intuitive CLI for managing Git worktrees"
  homepage "https://github.com/Radialarray/worktree-manager"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.1/worktree-manager-aarch64-apple-darwin.tar.xz"
    sha256 "e59779901d85eee5367c77615f872dbc35e152bb664808b7b8ace81a08310b87"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.1/worktree-manager-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8599ffbc2a842561a0f4f73fba384e45e01b5dc47d74049302bf0a407c8bab81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.1/worktree-manager-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6f5740e045c8f5e42efe9cb240ce92470d65aac03eef6c059cd24e15a1286987"
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
