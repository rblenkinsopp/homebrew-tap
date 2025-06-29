class ClangFormatAT14 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/llvm-14.0.6.src.tar.xz"
    sha256 "050922ecaaca5781fdf6631ea92bc715183f202f9d2f15147226f023414f619a"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/clang-14.0.6.src.tar.xz"
      sha256 "2b5847b6a63118b9efe5c85548363c81ffe096b66c3b3675e953e26342ae4031"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/rblenkinsopp/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49cd26573393bff46d6dc368c9e8b941618ceba85ba51c6c2aff6318e95e5148"
    sha256 cellar: :any_skip_relocation, ventura:       "b1f4e9895c00e5db91d9a794778e97eabf3578651669e6c3aa61ac1d2ca4dcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "083852e33ae63c7a09ee4b2553f4aa0a906bc9a3bfcac4083ca1ee7282192ca3"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      resource("clang").stage do |r|
        (buildpath/"llvm-#{version}.src/tools/clang").install Pathname("clang-#{r.version}.src").children
      end

      buildpath/"llvm-#{version}.src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    git_clang_format = llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    inreplace git_clang_format, %r{^#!/usr/bin/env python$}, "#!/usr/bin/env python3"

    bin.install "build/bin/clang-format", git_clang_format
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format")
  end
end
