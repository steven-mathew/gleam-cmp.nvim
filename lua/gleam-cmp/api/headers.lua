local headers = {}

function headers.get()
  return vim.tbl_extend("force", {
    ["Referer"] = "https://hex.pm",
    ["Origin"] = "https://hex.pm/",
    ["content-type"] = "application/json",
    ["Accept"] = "application/json",
    ["Host"] = "hex.pm",
  }, {})
end

return headers
