require 'json'

file "/tmp/dna.json" do
  content JSON.pretty_generate(node)
end
