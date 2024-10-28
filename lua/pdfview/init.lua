local parser = require('pdfview.parser')
local renderer = require('pdfview.renderer')
local telescope = require('telescope.builtin')

local M = {}

function M.open()
  telescope.find_files({
    prompt_title = "Select PDF",
    find_command = { "fd", ".pdf" },
    attach_mappings = function(_, map)
      -- When a file is selected, extract and display text
      map('i', '<CR>', function(prompt_bufnr)
        local selected_file = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
        require('telescope.actions').close(prompt_bufnr)

        local pdf_path = selected_file.path
        local text = parser.extract_text(pdf_path)
        if text then
          renderer.display_text(text)
        end
      end)
      return true
    end,
  })
end

return M

