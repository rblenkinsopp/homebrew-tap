class CmakeAT320 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.20.6/cmake-3.20.6.tar.gz"
  sha256 "a0bd485e1a38dd13c0baec89d5f4adbf61c7fd32fddb38eabc69a75bc0b65d72"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  keg_only :versioned_formula

  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # Remove OSXScriptLauncher as this doesn't support modern architectures
  patch :DATA

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end

__END__
diff --git a/Modules/Internal/CPack/CPack.OSXScriptLauncher.in b/Modules/Internal/CPack/CPack.OSXScriptLauncher.in
deleted file mode 100644
index c7158604..00000000
Binary files a/Modules/Internal/CPack/CPack.OSXScriptLauncher.in and /dev/null differ
diff --git a/Modules/Internal/CPack/CPack.OSXScriptLauncher.rsrc.in b/Modules/Internal/CPack/CPack.OSXScriptLauncher.rsrc.in
deleted file mode 100644
index 5f5f17a1..00000000
Binary files a/Modules/Internal/CPack/CPack.OSXScriptLauncher.rsrc.in and /dev/null differ
diff --git a/Source/CMakeLists.txt b/Source/CMakeLists.txt
index 6adc9cf6..b2dee048 100644
--- a/Source/CMakeLists.txt
+++ b/Source/CMakeLists.txt
@@ -1164,13 +1164,6 @@ if(CPACK_ENABLE_FREEBSD_PKG AND FREEBSD_PKG_INCLUDE_DIRS AND FREEBSD_PKG_LIBRARI
   add_definitions(-DHAVE_FREEBSD_PKG)
 endif()

-if(APPLE)
-  add_executable(OSXScriptLauncher
-    CPack/OSXScriptLauncher.cxx)
-  target_link_libraries(OSXScriptLauncher cmsys)
-  target_link_libraries(OSXScriptLauncher "-framework CoreFoundation")
-endif()
-
 # Build CMake executable
 add_executable(cmake cmakemain.cxx cmcmd.cxx cmcmd.h ${MANIFEST_FILE})
 list(APPEND _tools cmake)
diff --git a/Source/CPack/cmCPackOSXX11Generator.cxx b/Source/CPack/cmCPackOSXX11Generator.cxx
index 5de4a6f3..b05057cd 100644
--- a/Source/CPack/cmCPackOSXX11Generator.cxx
+++ b/Source/CPack/cmCPackOSXX11Generator.cxx
@@ -100,11 +100,6 @@ int cmCPackOSXX11Generator::PackageFiles()
       !this->CopyResourcePlistFile("OSXX11.Info.plist", contDir,
                                    "Info.plist") ||
       !this->CopyResourcePlistFile("OSXX11.main.scpt", scrDir, "main.scpt",
-                                   true) ||
-      !this->CopyResourcePlistFile("OSXScriptLauncher.rsrc", dir, rsrcFile,
-                                   true) ||
-      !this->CopyResourcePlistFile("OSXScriptLauncher", appdir,
-                                   this->GetOption("CPACK_PACKAGE_FILE_NAME"),
                                    true)) {
     cmCPackLogger(cmCPackLog::LOG_ERROR,
                   "Problem copying the resource files" << std::endl);
