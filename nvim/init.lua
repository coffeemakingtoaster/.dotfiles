-- Set options
require("coffeemakingtoaster.set")
-- Load plugins via Packer
require("coffeemakingtoaster.packer")
-- Start ts server
require'lspconfig'.tsserver.setup {}
print("Sourced")
