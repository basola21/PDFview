local parser = require("pdfview.parser")
local renderer = require("pdfview.renderer")
local telescope = require("telescope.builtin")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

-- Function to open the full PDF text (runs when PDF is selected)
function M.open(pdf_path)
	local text = parser.extract_text(pdf_path)
	if text then
		renderer.display_text(text)
	end
end

-- Function to extract and display the first page (used for preview)
function M.preview_first_page(pdf_path)
	local first_page_text = parser.extract_text(pdf_path, 1, 1)
	if first_page_text then
		return first_page_text
	else
		return "Could not extract text from the first page of the PDF."
	end
end

-- Custom previewer for Telescope to show the first page
local pdf_previewer = previewers.new_buffer_previewer({
	define_preview = function(self, entry)
		local pdf_path = entry.path
		local preview_text = M.preview_first_page(pdf_path)
		vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(preview_text, "\n"))
	end,
})

-- Telescope function with preview and open functionality
function M.telescope_open()
	telescope.find_files({
		prompt_title = "Select PDF",
		find_command = { "find", ".", "-type", "f", "-name", "*.pdf" },
		previewer = pdf_previewer,
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local selected_file = action_state.get_selected_entry(prompt_bufnr)
				actions.close(prompt_bufnr)
				local pdf_path = selected_file.path
				M.open(pdf_path)
			end)
			return true
		end,
	})
end

return M
