local M = {}

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

return M
