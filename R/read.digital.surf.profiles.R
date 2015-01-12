#-------------------------------------------------------------------
#Read in the profiles once the header info is known
#Fastest version
#-------------------------------------------------------------------
read.digital.surf.profiles<-function(pt,header.info)
{
  
  #Offset for profiles:
  offset<-512 + header.info$leng.comment.zone + header.info$leng.private.zone
  
  #Move the pointer to where the profiles begin:
  seek(pt, where = offset, rw="r")
  
  #Read out the profiles. Units should be un microns:
  #print(header.info$num.bits.pt)
  point.byte.depth<-header.info$num.bits.pt/8
  #print(point.byte.depth)
  surface3<-readBin(pt, what=integer(), size = point.byte.depth, n = ((header.info$num.pts.line)*(header.info$num.lines)), signed = TRUE, endian = "little")
  surface3<-(1000 * header.info$z.inc * t(matrix(surface3, ncol=header.info$num.lines, nrow=header.info$num.pts.line)))
  
  return(surface3)
  
}