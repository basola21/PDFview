local M = {}
local builtin = require('telescope.builtin')

-- Function to extract text from PDF using pdftotext
function M.extract_text(pdf_path)
  -- Check if the file exists
  if vim.fn.filereadable(pdf_path) == 0 then
    vim.api.nvim_err_writeln("PDFview: File does not exist: " .. pdf_path)
    return nil
  end

  -- Use pdftotext with the -layout option to preserve layout
  local cmd = string.format('pdftotext -layout "%s" -', pdf_path)
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  local success, exit_reason = handle:close()

  if not success then
    vim.api.nvim_err_writeln(string.format("PDFview: Failed to extract text from PDF. Exit reason: %s",
      exit_reason or "Unknown error"))
    return nil
  end

  return result
end

-- Function to open Telescope and select a PDF file
function M.select_pdf()
  builtin.find_files({
    prompt_title = "Select PDF",
    cwd = vim.fn.getcwd(), -- Start in the current directory
    find_command = { 'find', '.', '-type', 'f', '-name', '*.pdf' }, -- Restrict to PDF files
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      -- On selection of a file, pass the file to extract_text
      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Call extract_text with the selected PDF file
        local pdf_path = selection.path or selection[1]
        local result = M.extract_text(pdf_path)
        if result then
          vim.api.nvim_out_write(result)
        end
      end)

      return true
    end
  })
end

return M

