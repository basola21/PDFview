local M = {}

-- Function to extract text from PDF using pdftotext
function M.extract_text(pdf_path)
  if vim.fn.filereadable(pdf_path) == 0 then
    vim.api.nvim_err_writeln("PDFview: File does not exist: " .. pdf_path)
    return nil
  end

  -- Use pdftotext with the -layout option to preserve layout
  local cmd = string.format('pdftotext -layout "%s" -', pdf_path)
  local handle = io.popen(cmd)

  -- Check if handle is nil
  if not handle then
    vim.api.nvim_err_writeln("PDFview: Failed to open process for pdftotext.")
    return nil
  end

  local result = handle:read("*a")
  local success, _, exit_code = handle:close()

  if not success or exit_code ~= 0 then
    vim.api.nvim_err_writeln(string.format(
      "PDFview: Failed to extract text from PDF: %s\nExit Code: %d\nError Output: %s",
      pdf_path, exit_code, result))
    return nil
  end

  return result
end

return M
