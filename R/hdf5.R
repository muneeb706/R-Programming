# HDF5
# are used for storing lagrge data sets
# it means Hierarchical Data Format
# it contains groups of data with that have a group header with group name and list of attirbutes and metadata.
# Datasets are multidimensional array of data elements with metadata
# They have a header with name, datatype, dataspace, and storage layout and data array with data.

# installing R HDF5 package 

# BioCManager has a list of packages

if (!"BiocManager" %in% rownames(installed.packages())) {
    if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
        BiocManager::install()
}

if (!"rhdf5" %in% rownames(installed.packages())) {
    BiocManager::install("rhdf5")
}

library(rhdf5)

# creating hdf5 file
if (!file.exists("./data/example.h5")) {
    created = h5createFile("./data/example.h5")
}

# creating groups in the file

created = h5createGroup("./data/example.h5", "foo")
created = h5createGroup("./data/example.h5", "baa")
# create subgroup
created = h5createGroup("./data/example.h5", "foo/foobaa")

# list groups and metadata
h5ls("./data/example.h5")

# write datasets to groups

A = matrix(1:10, nr=5,nc=2)
h5write(A, "./data/example.h5", "foo/A")
B = array(seq(0.1, 2.0, by = 0.1), dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "./data/example.h5", "foo/foobaa/B")
h5ls("./data/example.h5")

df = data.frame(1L:5L, seq(0,1,length.out=5), c("ab", "cde", "fghi", "a", "s"), stringsAsFactors = FALSE)

h5f = H5Fopen("./data/example.h5")

if (length(h5f$df) < 1) {
    h5write(df, "./data/example.h5", "df")
}

h5ls("./data/example.h5")

# read data

readA = h5read("./data/example.h5", "foo/A")
readB = h5read("./data/example.h5", "foo/foobaa/B")
readdf = h5read("./data/example.h5", "df")
readA

# read and write chunks of data
# index is the portion of the dataset where you want to write
# in the following example we are writing in first 3 rows of first column
h5write(c(12,13,14), "./data/example.h5", "foo/A", index=list(1:3,1))
h5read("./data/example.h5","foo/A")
