class WorktreeManager < Formula
  desc "Fast, intuitive CLI for managing Git worktrees"
  homepage "https://github.com/Radialarray/worktree-manager"
  version "0.1.6"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.6/worktree-manager-aarch64-apple-darwin.tar.xz"
      sha256 "0490df2db953c2e8d5063e001d95e664570223f505bdc149ffeefda9080252c5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.6/worktree-manager-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ecf6b41deea64b334c92f36c80526c9a236333a4b12f5f49340099327d1d3c7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/worktree-manager/releases/download/v0.1.6/worktree-manager-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3f8d5489a8ce4d3b5914913e2b19633d8505b2a5ea885b93472b7635a34167e5"
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
