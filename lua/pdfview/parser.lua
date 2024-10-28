local M = {}

-- Function to extract text from PDF using pdftotext
function M.extract_text(pdf_path)
  if vim.fn.filereadable(pdf_path) == 0 then
    vim.api.nvim_err_writeln("PDFview: File does not exist: " .. pdf_path)
    return nil
  end

  -- Use vim.fn.shellescape to properly escape the file path
  local escaped_pdf_path = vim.fn.shellescape(pdf_path)

  -- Use pdftotext with the -layout option to preserve layout
  local cmd = string.format('pdftotext -layout %s - 2>&1', escaped_pdf_path)
  vim.api.nvim_out_write("Running command: " .. cmd .. "\n") -- Debug output

  local handle = io.popen(cmd)

  if not handle then
    vim.api.nvim_err_writeln("PDFview: Failed to open process for pdftotext.")
    return nil
  end

  local result = handle:read("*a")
  local success, exit_type, exit_code = handle:close()

  if not success or exit_code ~= 0 then
    vim.api.nvim_err_writeln(string.format(
      "PDFview: Failed to extract text from PDF: %s\nExit Type: %s\nExit Code: %s\nError Output: %s",
      pdf_path, tostring(exit_type), tostring(exit_code), result))
    return nil
  end

  return result
end

return M

