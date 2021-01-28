require(RCurl)
library(XML)


##increase your timeout limit to allow download of bigger files
options(timeout=180)


url = "https://hillcrestgeo.ca/outgoing/fishpassage/projects/elk/"

filenames <- getURL(url,verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)
filenames <- getHTMLLinks(filenames, xpQuery = "//a/@href[contains(., '.pdf')]") #https://stackoverflow.com/questions/32213591/list-files-on-http-ftp-server-in-r

# ##or more precisely
# getHTMLLinks(
#   filenames,
#   xpQuery = "//a/@href['.pdf'=substring(., string-length(.) - 3)]"
# )

for (filename in filenames) {
  download.file(paste(url, filename, sep = ""), paste(getwd(), "/", filename,
                                                      sep = ""), mode = "wb")
}


##now we will zip up the kml files in the data folder and rename with kmz
files_to_zip <- paste0("maps/", list.files(path = "maps/", pattern = "\\.pdf$"))  ##this used to includes the planning file which we don't want to do so watch out
zip::zipr("data/Attachment_2_maps.zip", files = files_to_zip)  ##it does not work to zip to kmz!!

