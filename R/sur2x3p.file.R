#--------------------------------------------
#' @title Convert a read in .sur file to x3p format
#'
#' @description Convert a read in .sur file to x3p format
#' 
#' @details It's necessary at this point to open the .sur file so
#' that point's can be converted to floats (or doubles), 
#' which as far as I can tell is required by the 
#' NanoFicus x3p library
#'
#' @param surf.info
#' @param extra.file.info.list
#' @param comment.list
#' @param fname
#' @param move.to.directory
#' 
#' @return a x3p file. 
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
sur2x3p.file <- function(surf.info, extra.file.info.list, comment.list, fname, move.to.directory){
  
  head.info <- surf.info[[1]]
  
  if(head.info["stud.typ"]==2){
    sur.type = "SUR"
  } else {
    print("Not supported")    #FIX ME
  }
  
  x.inc <- head.info["x.inc"][[1]]/1000 #convert mm to m #FIX ME ADD ERROR TRAP!
  y.inc <- head.info["y.inc"][[1]]/1000 #convert mm to m #FIX ME ADD ERROR TRAP!
  z.inc <- head.info["z.inc"][[1]]/1000 #?? unit ?? FIX ME ADD ERROR TRAP!
  num.pts.per.profile <- head.info["num.pts.line"] #FIX ME COMPARE TO DIMS OF surface matrix
  num.profile <- head.info["num.lines"]           #FIX ME COMPARE TO DIMS OF surface matrix
  z.off <- head.info[["z.off"]][[1]]
  
  data.fpath <- paste(tempdir(),"/ftmp/bindata/data.bin",sep="")
  #print(data.fpath)
  
  #Make a temp directory for file assembly
  system(paste("rm -rf",paste(tempdir(),"/ftmp/",sep=""))) #Remove directory structure if it is there first.
  system(paste("mkdir",paste(tempdir(),"/ftmp/",sep="")))
  system(paste("mkdir",paste(tempdir(),"/ftmp/bindata/",sep="")))
  
  fptr <- file(data.fpath, "wb")
  writeBin(1e-6 * as.numeric(t(surf.info[[2]])), data.fpath, size=4)
  close(fptr)
  
  chk.sum <- strsplit(system(paste("md5",data.fpath),intern=T)," ")[[1]][4]
  #print(chk.sum)
  
  #This is the format of the date/time in main.xml:
  tme.stmp <- strsplit(as.character(Sys.time()), " ")[[1]]
  tme.stmp <- paste(tme.stmp[1],"T",tme.stmp[2],"-03:00",sep="")
  
  options(warn=-1) #Shut off warnings generated by XML  
  main.xml<- make.x3p.header(
    surf.type      = sur.type, #ignored
    x.axis.type    = extra.file.info.list[["x.axis.type"]],
    x.data.type    = extra.file.info.list[["x.data.type"]],
    xinc           = x.inc,
    x.offset       = 0.0,    #Default start at (0,0)
    #
    y.axis.type    = extra.file.info.list[["y.axis.type"]],
    y.data.type    = extra.file.info.list[["y.data.type"]],
    yinc           = y.inc, 
    y.offset       = 0.0,    #Default start at (0,0)
    #
    z.axis.type    = extra.file.info.list[["z.axis.type"]],
    z.data.type    = extra.file.info.list[["z.data.type"]],
    zinc           = z.inc,
    z.offset       = z.off,    #This may not be 0, so fill it in. head.info[[1]][["z.off"]]
    #                          
    meas.dte       = tme.stmp,
    who.wrote.file = extra.file.info.list[["who.wrote.file"]],
    manufacturer   = extra.file.info.list[["manufacturer"]],
    model          = extra.file.info.list[["model"]],
    sn             = extra.file.info.list[["sn"]],
    vers           = extra.file.info.list[["vers"]],
    cal.dte        = extra.file.info.list[["cal.dte"]],
    probe.type     = extra.file.info.list[["probe.type"]],
    probe.id       = extra.file.info.list[["probe.id"]],
    #meas.comment   = extra.file.info.list[["meas.comment"]],
    meas.comment   = comment.list,
    pts.per.prof   = num.pts.per.profile, 
    num.prof       = num.profile,
    z.format       = extra.file.info.list[["z.format"]],
    data.bin.md5sumcheck = chk.sum
  )
  options(warn=1) #Turn warnings on again
  
  saveXML(main.xml,file=paste(tempdir(),"/ftmp/main.xml",sep=""))
  
  chk.sum.main <- strsplit(system(paste("md5",paste(tempdir(),"/ftmp/main.xml",sep="")),intern=T)," ")[[1]][4]
  write(chk.sum.main, paste(tempdir(),"/ftmp/md5checksum.hex",sep=""))
  
  system(paste("cd", paste(tempdir(),"/ftmp/;",sep=""),
               paste("zip", fname, "bindata/data.bin main.xml md5checksum.hex;"),
               paste("mv",fname,move.to.directory) 
  ))
  
  system(paste("rm -rf",paste(tempdir(),"/ftmp/",sep=""))) #Remove directory structure
  
}