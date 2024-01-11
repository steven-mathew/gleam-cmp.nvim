local packages = require("gleam-cmp.api.packages")

local source = {}

local opts = {
  only_latest_version = false,
  only_latest_stable_version = false,
}

source.new = function()
  local self = setmetatable({}, { __index = source })
  return self
end

function source:is_available()
  local filename = vim.fn.expand("%:t")
  return filename == "gleam.toml"
end

function source:get_debug_name()
  return "gleam-cmp"
end

function source:complete(params, callback)
  -- figure out if we are completing the package name or version
  local cur_line = params.context.cursor_line
  local cur_col = params.context.cursor.col
  local name = string.match(cur_line, '([^"= ]*)')
  local _, idx_after_third_quote = string.find(cur_line, ".*%s*=%s*\"")
  local find_version = false
  if idx_after_third_quote then
    find_version = cur_col >= idx_after_third_quote
  end
  if name == nil then
    return
  end

  if not find_version then
    -- TODO: search through package names
    return
  end

  local package = packages.by_slug(name) or {}

  local items = {}

  if opts.only_latest_stable_version then
    table.insert(items, { label = package.latest_stable_version })
  elseif opts.only_latest_version then
    table.insert(items, { label = package.latest_version })
  else
    for _, release in ipairs(package.releases or {}) do
      table.insert(items, { label = release.version })
    end
  end

  callback(items)
end

function source:resolve(completion_item, callback)
  callback(completion_item)
end

function source:execute(completion_item, callback)
  callback(completion_item)
end

require("cmp").register_source("gleam-cmp", source.new())

return {
  setup = function(_opts)
    if _opts then
      opts = vim.tbl_deep_extend("force", opts, _opts) -- will extend the default options
    end
  end,
}
