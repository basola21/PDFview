if has('nvim')
  command! -nargs=1 PDFview lua require('pdfview').open(<f-args>)
endif

