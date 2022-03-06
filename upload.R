library(aws.s3)
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("At least one argument must be supplied, the key", call.=FALSE)
}
print('uploading to AWS')


key = args[1]
secret = args[2] 
region=args[3]
bucket = args[4]

put_object(
  file = file.path(".", "CovidDashboard.html"), 
  object = "CovidDashboard.html", 
  bucket = bucket,
  multipart = TRUE,
  region = region,
  key = key, 
  secret = secret,
  headers=c('content-type' = 'text/html')
)

get_bucket(bucket = bucket,key = key, secret = secret ,region = region)
head_object(object='CovidDashboard.html', bucket = bucket,key = key, secret = secret ,region = region)
)


print('uploaded')
