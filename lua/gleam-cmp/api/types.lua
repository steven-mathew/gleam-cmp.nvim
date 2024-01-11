--------------------------------------------
--- Metadata
--------------------------------------------
---@class gc.PackageResponse.metadata
---@field description string
---@field licenses string[]
---@field maintainers string[]

---@alias gc.metadata gc.PackageResponse.metadata

--------------------------------------------
--- Release
--------------------------------------------
---@class gc.PackageResponse.release
---@field has_docs boolean
---@field inserted_at string
---@field version string
---@field url string
---@field meta gc.metadata

---@alias gc.release gc.PackageResponse.release

--------------------------------------------
--- Package Response /api/packages/{package_id}
--------------------------------------------

---@class gc.PackageResponse
---@field name string
---@field repository string
---@field url string
---@field latest_stable_version string
---@field latest_version string
---@field releases gc.release[]

---@alias gc.package_res gc.PackageResponse

--------------------------------------------
--- Error
--------------------------------------------
---@class gc.Api.err
---@field status integer
---@field message string
---@field err string

---@alias gc.err gc.Api.err|nil
