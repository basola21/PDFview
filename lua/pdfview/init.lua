local parser = require('pdfview.parser')
local renderer = require('pdfview.renderer')
local telescope = require('telescope.builtin')

local M = {}

function M.open()
  telescope.find_files({
    prompt_title = "Select PDF",
    find_command = { "fd", ".pdf" },
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local actions = require('telescope.actions')
        local state = require('telescope.actions.state')

        -- Get selected entry
        local selected_file = state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Extract text and render it
        local pdf_path = selected_file.path
        local text = parser.extract_text(pdf_path)
        if text then
          renderer.display_text(text)
        else
          vim.api.nvim_err_writeln("Failed to extract text from PDF: " .. pdf_path)
        end
      end)
      return true -- Make sure to return true here
    end,
  })
end

return M
