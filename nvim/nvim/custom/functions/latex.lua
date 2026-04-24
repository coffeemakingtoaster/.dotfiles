local M = {}

M.compile_latex = function()
	local file = vim.fn.expand("%:p") -- Get the full path of the current file
	if vim.fn.expand("%:e") ~= "tex" then
		print("Not a .tex file")
		return
	end
	if vim.fn.executable("latexmk") == 0 then
		print("Compilation failed. Check log file for further details.")
	end

	local cmd = "latexmk -pdf " .. file .. " > /dev/null 2>&1" -- Redirect output
	local result = os.execute(cmd) -- Run the command and capture the exit code

	if result == 0 then
		print("Compilation successful!")
	else
		print("Compilation failed. Check log file for further details.")
	end
end

return M
