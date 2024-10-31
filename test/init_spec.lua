local pdfview = require("pdfview")

describe("PDFView Module Integration", function()

  it("should preview the first page", function()
    local pdf_path = "test/files/test_pdf_with_images.pdf"
    local preview_text = pdfview.preview_first_page(pdf_path)
    assert(preview_text and #preview_text > 0, "Expected non-empty preview text")
  end)

  it("should open and display the entire PDF text", function()
    local pdf_path = "test/files/test_pdf_with_images.pdf"
    pdfview.open(pdf_path)
    local buf_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    assert(#buf_content > 0, "Expected buffer to contain PDF text")
  end)

end)
