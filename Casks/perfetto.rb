cask "perfetto" do
  name "perfetto"
  desc "System profiling, app tracing and trace analysis"
  homepage "https://perfetto.dev"

  version "49.0"
  arch arm: "arm64", intel: "amd64"
  sha256 arm: "cece033ea84f9c004588ba6006ba204bacd6cedaf8c7deb59d7ebeedff884ba9",
      intel: "b20331ccea9712de95618d7973abe14b7f9985c752eda1bc485f3c795621a290"
  url "https://github.com/google/perfetto/releases/download/v#{version}/mac-#{arch}.zip",
      verified: "https://github.com/google/perfetto/releases/download/"

  livecheck do
    url "https://github.com/google/perfetto.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  caveats "This cask must be installed with the --no-quarantine option"

  binary "mac-#{arch}/perfetto"
  binary "mac-#{arch}/trace_processor_shell"
  binary "mac-#{arch}/tracebox"
  binary "mac-#{arch}/traceconv"
  binary "mac-#{arch}/traced"
  binary "mac-#{arch}/traced_probes"
end
