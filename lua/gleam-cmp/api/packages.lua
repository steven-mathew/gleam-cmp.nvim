local utils = require("gleam-cmp.api.utils")
local urls = require("gleam-cmp.api.urls")

---@class gc.PackagesApi
local Packages = {}

---@param slug string
---
---@return gc.PackageResponse|nil, gc.err
function Packages.by_slug(slug)
  local endpoint = urls.packages:format(slug)

  local res, err = utils.get(endpoint, nil)
  if err then
    return nil, err
  end

  -- TODO: transform this to a business object instead
  return res, nil
end

return Packages
