class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.6.0/abcl-src-1.6.0.tar.gz"
  sha256 "893fce815d3fc9a3aa250c78ff84ed2e51b702f71cb11e1befc2a2ec9c666b43"
  head "https://abcl.org/svn/trunk/abcl/", :using => :svn

  bottle do
    cellar :any_skip_relocation
    sha256 "f38b36c98f322d4a01a749e2c3e070231168017261862b36c50d88e58807aaa5" => :catalina
    sha256 "5eefea90ac903b73abb042dd77d56b38d4183b6ab2bad53506704d6df352b6f7" => :mojave
    sha256 "8a5e39a470e5022e17c503218cadf989cdda645a94511954f7af5959107e79a9" => :high_sierra
    sha256 "bb56fa9880fc0d627d94f3d0fa63b1979f6acf24c4dd40de3102dd51736f90ea" => :sierra
    sha256 "300b8eef97c11953cfe37e28a5cea6ff5e0734c49e08ba8527743156ef9ad04e" => :el_capitan
  end

  depends_on "ant"
  depends_on :java => "1.8"
  depends_on "rlwrap"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write <<~EOS
      #!/bin/sh
      export JAVA_HOME=$(#{cmd})
      rlwrap java -cp #{libexec}/abcl.jar:"$CLASSPATH" org.armedbear.lisp.Main "$@"
    EOS
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match /"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip
  end
end
