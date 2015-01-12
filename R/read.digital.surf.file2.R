#-------------------------------------------------------------------
#Faster read in a Digital Surf file wrapper. Calls a faster C++ routine
#via Rcpp. Just specify the path to the
#.sur file. Use fle.choose() to open a file chooser window 
#-------------------------------------------------------------------
read.digital.surf.file2<-function(file.path) {
  
  surface.info<-readSurFile(file.path)
  
  #Unwrap the list of lists output by the above Rcpp function.
  header.info<-rep(list(NULL),63)
  count<-1
  name.list<-NULL
  for(i in 1:4){
    head.list<-surface.info[[i]]
    name.list<-c(name.list,names(head.list))
    for(j in 1:length(head.list)) {
      header.info[[count]] <- head.list[[j]]
      count <- count + 1
    }
  }
  names(header.info)<-name.list
  
  surface.matrix<-header.info[["surface"]]
  surface.matrix<-t(matrix(surface.matrix,ncol=header.info[["num.lines"]],nrow=header.info[["num.pts.line"]]))
  all.file.info<-c(list(NULL),list(NULL))
  names(all.file.info)<-c("Surface Info","Surface")
  all.file.info[[1]]<-header.info[-63]
  all.file.info[[2]]<-surface.matrix
  
  return(all.file.info)
  
}