##this is for as we work through
# preview_chapter('index.Rmd')
preview_chapter('0300-method.Rmd')
preview_chapter('0400-results.Rmd')
# preview_chapter('0200-background.Rmd')
# preview_chapter('0800-appendix-050155.Rmd')
# preview_chapter('0800-appendix-050181.Rmd') ##nupku
# preview_chapter('0800-appendix-050185.Rmd')
# preview_chapter('0800-appendix-062423.Rmd')
# preview_chapter('0800-appendix-062425.Rmd')
# preview_chapter('0800-appendix-062516.Rmd')
# preview_chapter('0800-appendix-197534.Rmd')
# preview_chapter('0800-appendix-197533.Rmd')
# preview_chapter('0800-appendix-197555.Rmd')



##for a prod build


##change your VErsion #

##move the phase 1 appendix out of the main directory to a backup file
file.rename('0600-appendix.Rmd', 'data/0600-appendix.Rmd')

##go to the index.Rmd doc and turn
#html_on <- FALSE and change
#font_set <- 9
#photo_width <- "80%"
# caption_font <- 11

##   then make our printable pdf
rmarkdown::render_site(output_format = 'pagedown::html_paged', encoding = 'UTF-8')
# pagedown::chrome_print("index.Rmd")

##  move it to the docs folder so that it can be seen by the download button
file.rename('Elk.html', 'docs/Elk.html')

##move the phase 1 appendix back to main directory
file.rename('data/0600-appendix.Rmd', '0600-appendix.Rmd')

##go to the index.Rmd doc and turn
#html_on <- TRUE and change
#font_set <- 11
#photo_width <- "100%"


##now we need to print the docs/Elk.html file to Elk.pdf with chrome.  We should automate this step.  Do in browser for now
openHTML('docs/Elk.html')




##  make the site
rmarkdown::render_site(output_format = 'bookdown::gitbook', encoding = 'UTF-8')


##########################################this should be complete now and not necessary to repeat
#################################################################################################
##we need a workflow to print the Phase 1 attachment
files_to_move <- list.files(pattern = ".Rmd$") %>%
  stringr::str_subset(., 'index|Elk|0600', negate = T)
files_destination <- paste0('hold/', files_to_move)

mapply(file.rename, from = files_to_move, to = files_destination)

##   then make our printable pdf
rmarkdown::render_site(output_format = 'pagedown::html_paged', encoding = 'UTF-8')

##  move it to the docs folder so that it can be in the same place as the report
file.rename('Elk.html', 'docs/Attachment_3_Phase_1_Data_and_Photos.html')

##move the files from the hold file back to the main file
mapply(file.rename, from = files_destination, to = files_to_move)

##go to the docs folder - print the attachment to pdf

##now get rid of the first 5 pages
length <- pdf_length(paste0(getwd(), "/docs/Attachment_3_Phase_1_Data_and_Photos_prep.pdf"))

pdf_subset(paste0(getwd(), "/docs/Attachment_3_Phase_1_Data_and_Photos_prep.pdf"),
           pages = 7:length, output = paste0(getwd(), "/docs/Attachment_3_Phase_1_Data_and_Photos.pdf"))

##clean out the old file
file.remove(paste0(getwd(), "/docs/Attachment_3_Phase_1_Data_and_Photos_prep.pdf"))

##we cannot sub in the title page because the TOC stops working when we do.
# length <- pdf_length(paste0(getwd(), "/docs/Elk.pdf"))
#
# pdf_subset(paste0(getwd(), "/docs/Elk.pdf"),
#            pages = 2:length, output = paste0(getwd(), "/docs/Elk2.pdf"))
#
# pdf_combine(c(paste0(getwd(), "/docs/title_page.pdf"),
#   paste0(getwd(), "/docs/Elk2.pdf")),
#             output = paste0(getwd(), "/docs/Elk3.pdf"))
#
# file.rename(paste0(getwd(), "/docs/Elk3.pdf"), paste0(getwd(),"/docs/Elk.pdf"))
#
# file.remove(paste0(getwd(), "/docs/Elk2.pdf"))
