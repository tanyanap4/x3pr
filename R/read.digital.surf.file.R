#--------------------------------------------
#' @title Read in a Digital Surf file wrapper. Just specify the path to the
#' .sur file.
#'
#' @description Read in a Digital Surf file wrapper. Just specify the path to the
#' .sur file.
#' 
#' @details Use fle.choose() to open a file chooser window 
#'
#' @param file.path
#' 
#' @return a matrix.
#' 
#' @references http://open-gps.sourceforge.net/
#'
#' @examples
#' Coming soon.
#'
#' \dontrun{
#'  
#' }
#--------------------------------------------
read.digital.surf.file<-function(file.path) {
  
  ptr<-file(file.path, "rb") #Open up a connection to the .sur file
  header.info<-read.digital.surf.header(ptr)
  surface.matrix<-read.digital.surf.profiles(ptr,header.info)
  close(ptr)
  
  all.file.info<-c(list(NULL),list(NULL))
  names(all.file.info)<-c("Surface Info","Surface")
  all.file.info[[1]]<-header.info
  all.file.info[[2]]<-surface.matrix
  
  return(all.file.info)
  
}