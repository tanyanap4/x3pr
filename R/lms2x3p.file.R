#--------------------------------------------
#' @title Convert a Zeiss LMS file to an X3P format.
#'
#' @description Convert a Zeiss LMS file to an X3P format.
#' 
#' @details Convert a Zeiss LMS file to an X3P format and writes the result to file. \code{move.to.directory}
#' is the path where to move the file. The file itself is initiall written to \code{tempdir()}.
#'
#' @param  surf.info surface information returned from read.zeiss.lms.file
#' @param  extra.file.info.list extra information required by ISO standards 
#' @param  comment.list optional comments on how the data was obtained.
#' @param  fname name for the .x3p file to be written
#' @param  move.to.directory path where to move the file. 
#' @return Nothing.
#'
#' @examples
#' Coming soon.
#'
#' \dontrun{
#'  
#' }
#--------------------------------------------
lms2x3p.file <- function(surf.info, extra.file.info.list, comment.list, fname, move.to.directory){
  print("This is not functioning yet!")
}