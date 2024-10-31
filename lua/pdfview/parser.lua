local M = {}

-- Check if the PDF file exists
local function file_exists(pdf_path)
	return vim.fn.filereadable(pdf_path) ~= 0
end

-- Build the shell command for extracting text
local function build_command(pdf_path, start_page, end_page)
	local escaped_pdf_path = vim.fn.shellescape(pdf_path)
	local page_args = ""
	if start_page and end_page then
		page_args = string.format("-f %d -l %d", start_page, end_page)
	end
	return string.format("pdftotext -layout %s %s -", page_args, escaped_pdf_path)
end

-- Run the shell command and return the output
local function run_command(cmd)
	local result = vim.fn.system(cmd)
	if result and #result > 0 then
		return result
	else
		vim.api.nvim_err_writeln("PDFview: Failed to extract text from PDF.")
		return nil
	end
end

-- Main function to extract text from the PDF with optional page range
function M.extract_text(pdf_path, start_page, end_page)
	if not file_exists(pdf_path) then
		vim.api.nvim_err_writeln("PDFview: File does not exist: " .. pdf_path)
		return nil
	end

	local cmd = build_command(pdf_path, start_page, end_page)
	return run_command(cmd)
end

return M
