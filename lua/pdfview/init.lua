local parser = require("pdfview.parser")
local renderer = require("pdfview.renderer")
local telescope = require("telescope.builtin")

local M = {}

function M.open(pdf_path)
	local text = parser.extract_text(pdf_path)
	if text then
		renderer.display_text(text)
	end
end

function M.telescope_open()
	-- telescope prompt
	telescope.find_files({
		prompt_title = "Select PDF",
		find_command = { "fd", ".pdf" },
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local selected_file = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
				require("telescope.actions").close(prompt_bufnr)
				local pdf_path = selected_file.path
				-- open pdf
				M.open(pdf_path)
			end)
			return true
		end,
	})
end

return M
