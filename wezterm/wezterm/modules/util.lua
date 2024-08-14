local util = {}

function util.joinPaths(...)
	local separator = package.config:sub(1, 1) -- Determine the separator (first character of package.config)
	local paths = { ... } -- Collect all arguments into a table
	local result = table.concat(paths, separator) -- Concatenate paths using the separator
	return result
end

return util
