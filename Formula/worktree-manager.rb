class WorktreeManager < Formula
  desc "Fast, intuitive CLI for managing Git worktrees"
  homepage "https://github.com/Radialarray/worktree-manager"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.1/worktree-manager-aarch64-apple-darwin.tar.xz"
    sha256 "614131e30e36f4006ffe74f0e2a7dd6f6eb3556e8ba459430a916f58f620b5f0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.1/worktree-manager-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b731b0f440ea1265546a78101b7756a8a5ae9d9265830894040be4a5ac9781f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.1/worktree-manager-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e32501127aae46390883641d9b9556fdfb5be0d7b4a4d803a9d4453028077ee"
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
