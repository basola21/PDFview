local M = {}

function M.extract_text(pdf_path)
  if vim.fn.filereadable(pdf_path) == 0 then
    vim.api.nvim_err_writeln("PDFview: File does not exist: " .. pdf_path)
    return nil
  end

  -- Use vim.fn.shellescape to properly escape the file path
  local escaped_pdf_path = vim.fn.shellescape(pdf_path)

  -- Use pdftotext with the -layout option
  local cmd = string.format('pdftotext -layout %s -', escaped_pdf_path)
  vim.api.nvim_out_write("Running command: " .. cmd .. "\n") -- Debug output

  -- Use vim.fn.system to run the command and capture output
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  -- Proceed if text was extracted, even if exit_code is non-zero
  if result and #result > 0 then
    return result
  else
    vim.api.nvim_err_writeln(string.format(
      "PDFview: Failed to extract text from PDF: %s\nExit Code: %s\nError Output: %s",
      pdf_path, exit_code, result))
    return nil
  end
end

return M

