class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2019-11-01.tar.gz"
  version "20191101"
  sha256 "5229d7e801bdb3d62a1b9d82de7c74eda223cb5e264d5bd04bcf31a933245d27"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "82e00713a39095bba2443ddf52a45c62a4072708af72f048ff2ae62f7354b206" => :catalina
    sha256 "969e37f92d4a9458c8fa8d1656b32edf010d82b5517dd70459ed9b64b6b03088" => :mojave
    sha256 "859bd1400bf5fe39361ca00a578758d5f6bc473e408f3139b0e702dc36599868" => :high_sierra
    sha256 "22b2549722a0b424a46b98494402e327084eea78de40cdf3a5962f7a5d7257f4" => :sierra
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.0.0.0.dylib", "#{lib}/libre2.0.dylib")
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
