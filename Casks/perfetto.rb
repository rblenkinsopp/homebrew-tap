cask "perfetto" do
  arch arm: "arm64", intel: "amd64"
  os macos: "mac", linux: "linux"

  version "50.1"
  sha256 arm:          "d56233c2629ea325841351c80fc75abcc77f13ab6d01251319b8844ed328302f",
         intel:        "68133999f79552e79402a5c7696ef7eed357f1ff376ef5318bccd74b1f151dcb",
         arm64_linux:  "93ec14ff907f0188edec7e74695d9e55106a520e93c82e7bb7bd27ee2b535a55",
         x86_64_linux: "7165d3ee71e13204f37c16ff0bff8bb6e73f2c484a33b85d1a185bd81930c3a5"

  url "https://github.com/google/perfetto/releases/download/v#{version}/#{os}-#{arch}.zip",
      verified: "github.com/google/perfetto/releases/download/"
  name "perfetto"
  desc "System profiling, app tracing and trace analysis"
  homepage "https://perfetto.dev/"

  livecheck do
    url "https://github.com/google/perfetto.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  binary "#{os}-#{arch}/perfetto"
  binary "#{os}-#{arch}/trace_processor_shell"
  binary "#{os}-#{arch}/tracebox"
  binary "#{os}-#{arch}/traceconv"
  binary "#{os}-#{arch}/traced"
  binary "#{os}-#{arch}/traced_probes"
end
