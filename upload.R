library(AzureStor)
options(azure_storage_progress_bar=TRUE)
print("Uploading to azure")
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("At least one argument must be supplied, the key", call.=FALSE)
}

cont <- blob_container(endpoint=paste("https://",args[1],".blob.core.windows.net/$web",sep=""),
                       key=args[2])
upload_blob(cont, args[3], dest=args[3])
print("Uploaded to azure")

