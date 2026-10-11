class EdfTool < Formula
  desc "Monthly export-of-services invoice + HDFC EDF form generator (fully offline)"
  homepage "https://github.com/krushiraj/edf-tool"
  url "https://github.com/krushiraj/edf-tool/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9c18c4d3f5a7877dc679eefc0265a0623a1c26cf7baf2bc006df440e592ce8c0"
  license "MIT"

  depends_on "python@3.13"

  def install
    # Pure standard-library Python: no virtualenv or resources needed.
    libexec.install "src/edf_tool"
    python = Formula["python@3.13"].opt_bin/"python3.13"
    (bin/"edf").write <<~SH
      #!/bin/bash
      exec "#{python}" -I -c 'import sys; sys.path.insert(0, "#{libexec}"); from edf_tool.cli import main; sys.exit(main())' "$@"
    SH
    chmod 0755, bin/"edf"
    man1.install_symlink libexec/"edf_tool/data/edf.1"
  end

  def caveats
    <<~EOS
      Get started:
        edf init          # one-time setup (stored in ~/.config/edf-tool, never uploaded)
        edf generate      # every month

      The bank form PDF needs LibreOffice (optional; the invoice PDF and Excel don't):
        brew install --cask libreoffice

      Currently supports HDFC Bank's Export of Services EDF form only.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/edf --version")
    assert_match "EXIT STATUS", shell_output("#{bin}/edf man --plain")
    assert_match "hdfc_services", shell_output("#{bin}/edf banks")
  end
end
