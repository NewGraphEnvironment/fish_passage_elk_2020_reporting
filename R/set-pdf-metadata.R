##set the metadata in the pdf - https://stackoverflow.com/questions/18647777/is-there-a-way-to-add-author-metadata-to-a-pdf-created-from-r
###############this does not work yet#########################

##also check out https://askubuntu.com/questions/27381/how-to-edit-pdf-metadata-from-command-line

# To get metadata:
getexif <- function(file, exiftool='exiftool.exe', opts=NULL,
                    intern=TRUE, simplify=FALSE) {
  # file: the file to be updated
  # exiftool: the path to the ExifTool binary
  # opts: additional arguments to ExifTool (optional)
  # intern: should a named vector of metadata be returned? (bool)
  # simplify: if intern==TRUE, should the results be returned as a named
  #           vector (TRUE) or as a data.frame (FALSE)?
  arg <- c(opts, normalizePath(file))
  if(intern) {
    exif <- system2(normalizePath(exiftool), args=arg, stdout=TRUE)
    exif <- do.call(rbind, strsplit(exif, ' +: +', perl=T))
    row.names(exif) <- exif[, 1]
    exif[, 2, drop=simplify]
  } else {
    system2(normalizePath(exiftool), args=arg, stdout='')
  }
}

# To set metadata:

  setexif <- function(file, ..., exiftool='exiftool.exe') {
    # file: the file to be updated
    # ...: metadata items
    # exiftool: the path to the ExifTool binary
    dots <- list(...)
    exif <- sprintf('-%s="%s"', names(dots), dots)
    system2(exiftool, args=c(exif, file))
  }


# WARNING - at this point this code erases the content

toolpath <-   "C:/Program Files/exiftool/exiftool(-k).exe"
f <-  "C:/Users/allan/OneDrive/New_Graph/Current/2020-025_cwf_elk/scripts/hold/Elk.pdf"

getexif(f, toolpath)

##if we add pdf(f) below we get a bit of action but I am not sure what is happening
setexif(f, c(title = "Elk Report Yo", subject='Fish Passage', author = "Allan Irvine"), exiftool=toolpath)

