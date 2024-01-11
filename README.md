# gleam-cmp.nvim

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

This is a source for [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) that autocompletes
[hexpm](https://hex.pm/) packages and its versions. It's active only within a `gleam.toml` file.

## Requirements
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

## Installation

For [packer](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'steven-mathew/gleam-cmp',
  requires = {
    'nvim-lua/plenary.nvim'
  }
}
```

For [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "steven-mathew/gleam-cmp",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = "toml",
  config = function()
    require("gleam-cmp").setup {}
  end
}
```

## Configuration

Please refer to the default settings below.

```lua
require("gleam-cmp.nvim").setup({
    only_latest_version = false,
    only_latest_stable_version = false,
})
```

Add the nvim-cmp source.

```lua

cmp.setup({
  ...,
  sources = {
    { name = "gleam", keyword_length = 3 },
    ...,
  },
})
```
