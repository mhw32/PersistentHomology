#!/usr/bin/env Rscript
source('testlib.r')
source('process_eagle.r')

args = commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
  stop(paste(
    "At least 2 arguments must be supplied ",
    "(dataDir[string], outDir[string]).\n",
    sep="",
  ), call.=FALSE)
} else {
    dataDir <- args[1]
    outDir <- args[2]
}

if (substr(dataDir, nchar(dataDir), nchar(dataDir)+1) != "/") {
  dataDir <- paste(dataDir, "/", sep="")
}

if (substr(outDir, nchar(outDir), nchar(outDir)+1) != "/") {
  outDir <- paste(outDir, "/", sep="")
}

for (i in 2:4) {
  print(paste('Executing Eagle set [base=cdm, norm=False]: ', i))
  cdm <- readRDS(paste(dataDir, "cdm_diags_", i, ".rds", sep=""))
  wdm <- readRDS(paste(dataDir, "wdm_diags_", i, ".rds", sep=""))
  bigset <- vector('list', 1)
  bigset[[1]] <- cdm
  test_wrapper(
    bigset, wdm, norm=FALSE, run_base=FALSE,
    ext=paste(paste("split=[", i, "]", sep=""), "norm=[0]", "base=[cdm]", sep="_"),
    folder=outDir
  )

  print(paste('Executing Eagle set [base=cdm, norm=True]: ', i))
  cdm <- readRDS(paste(dataDir, "cdm_diags_", i, ".rds", sep=""))
  wdm <- readRDS(paste(dataDir, "wdm_diags_", i, ".rds", sep=""))
  bigset <- vector('list', 1)
  bigset[[1]] <- cdm
  test_wrapper(
    bigset, wdm, norm=TRUE, run_base=FALSE,
    ext=paste(paste("split=[", i, "]", sep=""), "norm=[1]", "base=[cdm]", sep="_"),
    folder=outDir
  )

  print(paste('Executing Eagle set [base=wdm, norm=False]: ', i))
  cdm <- readRDS(paste(dataDir, "cdm_diags_", i, ".rds", sep=""))
  wdm <- readRDS(paste(dataDir, "wdm_diags_", i, ".rds", sep=""))
  bigset <- vector('list', 1)
  bigset[[1]] <- wdm
  test_wrapper(
    bigset, cdm, norm=FALSE, run_base=FALSE,
    ext=paste(paste("split=[", i, "]", sep=""), "norm=[0]", "base=[wdm]", sep="_"),
    folder=outDir
  )

  print(paste('Executing Eagle set [base=wdm, norm=True]: ', i))
  cdm <- readRDS(paste(dataDir, "cdm_diags_", i, ".rds", sep=""))
  wdm <- readRDS(paste(dataDir, "wdm_diags_", i, ".rds", sep=""))
  bigset <- vector('list', 1)
  bigset[[1]] <- wdm
  test_wrapper(
    bigset, cdm, norm=TRUE, run_base=FALSE,
    ext=paste(paste("split=[", i, "]", sep=""), "norm=[1]", "base=[wdm]", sep="_"),
    folder=outDir
  )
}
