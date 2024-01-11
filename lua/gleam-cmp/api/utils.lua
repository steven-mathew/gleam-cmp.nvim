-- Adapted from https://github.com/kawre/leetcode.nvim/blob/master/lua/leetcode/api/utils.lua

local curl = require("plenary.curl")
local urls = require("gleam-cmp.api.urls")
local headers = require("gleam-cmp.api.headers")

---@class gc.Utils
local utils = {}

---@param endpoint string
---@param opts? table
function utils.get(endpoint, opts)
  local options = vim.tbl_deep_extend("force", {
    endpoint = endpoint,
  }, opts or {})

  return utils.curl("get", options)
end

---@private
---@param method string
---@param params table
function utils.curl(method, params)
  local params_cpy = vim.deepcopy(params)

  params = vim.tbl_deep_extend("force", {
    headers = headers.get(),
    compressed = false,
    retry = 5,
    endpoint = urls.base,
  }, params or {})
  local url = ("https://hex.pm%s"):format(params.endpoint)

  if type(params.body) == "table" then
    params.body = vim.json.encode(params.body)
  end

  local tries = params.retry
  local function should_retry(err)
    return err and err.status >= 500 and tries > 0
  end

  if params.callback then
    local cb = vim.schedule_wrap(params.callback)
    params.callback = function(out, _)
      local res, err = utils.handle_res(out)

      if should_retry(err) then
        params_cpy.retry = tries - 1
        utils.curl(method, params_cpy)
      else
        cb(res, err)
      end
    end

    curl[method](url, params)
  else
    local out = curl[method](url, params)
    local res, err = utils.handle_res(out)

    if should_retry(err) then
      params_cpy.retry = tries - 1
      utils.curl(method, params_cpy)
    else
      return res, err
    end
  end
end

---@private
---@return table, gc.err
function utils.handle_res(out)
  local res, err

  if out.exit ~= 0 then
    err = {
      code = out.exit,
      msg = "curl failed",
    }
  elseif out.status >= 300 then
    local ok, msg = pcall(function()
      local dec = vim.json.decode(out.body)

      if dec.error then
        return dec.error
      end

      local tbl = {}
      for _, e in ipairs(dec.errors) do
        table.insert(tbl, e.message)
      end

      return table.concat(tbl, "\n")
    end)

    res = out.body
    err = {
      code = 0,
      status = out.status,
      response = out,
      msg = "http error " .. out.status .. (ok and ("\n\n" .. msg) or ""),
      out = out.body,
    }
  else
    res = vim.json.decode(out.body)
  end

  return res, utils.check_err(err)
end

---@param err gc.err
function utils.check_err(err)
  if not err then
    return
  end

  return err
end

return utils
