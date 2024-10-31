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

function M.preview_first_page(pdf_path)
	local first_page_text = parser.extract_text(pdf_path, 1, 1)
	if first_page_text then
		renderer.display_text(first_page_text)
	else
		print("Could not extract text from the first page of the PDF.")
	end
end

function M.telescope_open()
	telescope.find_files({
		prompt_title = "Select PDF",
    find_command = { "find", ".", "-type", "f", "-name", "*.pdf" },
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local selected_file = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
				require("telescope.actions").close(prompt_bufnr)
				local pdf_path = selected_file.path
				M.preview_first_page(pdf_path)
			end)
			return true
		end,
	})
end

return M
