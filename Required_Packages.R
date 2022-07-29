#Install packages if not installed
List_of_packages = c("Shiny",
                     "Shinydashboard",
                     "DT",
                     "DiffBind",
                     "tidyverse",
                     "DESeq2",
                     "edgeR",
                     "shinyjqui",
                     "shinyWidgets",
                     "shinycssloaders",
                     "circlize",
                     "ChIPseeker",
                     "org.Hs.eg.db",
                     "org.Mm.eg.db",
                     "TxDb.Mmusculus.UCSC.mm10.knownGene",
                     "TxDb.Hsapiens.UCSC.hg19.knownGene",
                     "pheatmap",
                     "RColorbrewer",
                     "clusterProfiler",
                     "reshape",
                     "ggplot2",
                     "colourpicker",
                     "ggupset")


for (i in range(List_of_packages)) {
      if (!require(i)) {
      install.packages(List_of_packages)
        } else if (require(i)) {
        }
    }
 

a = c(1:10)

for (i in range(a)) {
  print(i)
}

