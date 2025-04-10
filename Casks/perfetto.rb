cask "perfetto" do
  arch arm: "arm64", intel: "amd64"
  os macos: "mac", linux: "linux"

  version "49.0"
  sha256 arm:          "cece033ea84f9c004588ba6006ba204bacd6cedaf8c7deb59d7ebeedff884ba9",
         intel:        "b20331ccea9712de95618d7973abe14b7f9985c752eda1bc485f3c795621a290",
         arm64_linux:  "30f20cb58140c767e8fdc6a3ed2cad6784df50d700837f4c1cadb3f83acf0faf",
         x86_64_linux: "21112a8243afb5476e73c0b07895c4d1df2124ae330e7dd5951aaf008cd98df2"

  url "https://github.com/google/perfetto/releases/download/v#{version}/#{os}-#{arch}.zip",
      verified: "github.com/google/perfetto/releases/download/"
  name "perfetto"
  desc "System profiling, app tracing and trace analysis"
  homepage "https://perfetto.dev/"

  livecheck do
    url "https://github.com/google/perfetto.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  binary "mac-#{arch}/perfetto"
  binary "mac-#{arch}/trace_processor_shell"
  binary "mac-#{arch}/tracebox"
  binary "mac-#{arch}/traceconv"
  binary "mac-#{arch}/traced"
  binary "mac-#{arch}/traced_probes"
end
