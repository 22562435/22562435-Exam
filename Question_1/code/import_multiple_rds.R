import_multiple_rds <- function(pathway = "data/.") { # initial pathway is assumed to be data/.
    temp <- list.files(path = pathway, pattern = "\\.rds$") # fetching the file names and saves them as temp for naming purposes
    for (i in 1:length(temp)) { # loops for the length of temp
        file_name <- gsub(pattern = "\\.rds$", replacement = "", x = temp[i]) # removes .rds
        assign(file_name, readRDS(file.path(pathway, temp[i])), envir = .GlobalEnv)
    }
    rm(i, temp) # removing temporary variables- redundant since in function
}

