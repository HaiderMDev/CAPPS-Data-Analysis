Install packages if not installed
installReqs <- function(package_name, bioc) {
  if (requireNamespace(package_name, quietly = TRUE) == FALSE) {
    if (bioc == FALSE)
      install.packages(package_name)
    else if (bioc == TRUE) #install using Bioconductor package manager
      BiocManager::install(package_name)
  }
}

#install and upload packages:
#check if required libraries are installed, and install them if needed
installReqs("BiocManager", bioc = FALSE)
installReqs("shiny", bioc = TRUE)
installReqs("shinydashboard", bioc = TRUE)
installReqs("DT", bioc = TRUE)
installReqs("tidyverse", bioc = TRUE)
installReqs("DiffBind", bioc = TRUE)
installReqs("DESeq2", bioc = TRUE)
installReqs("edgeR", bioc = TRUE)
installReqs("shinyjqui", bioc = TRUE)
installReqs("shinyWidgets", bioc = TRUE)
installReqs("shinycssloaders", bioc = TRUE)
installReqs("circlize", bioc = TRUE)
installReqs("ChIPseeker", bioc = TRUE)
installReqs("org.Hs.eg.db", bioc = TRUE)
installReqs("org.Mm.eg.db", bioc = TRUE)
installReqs("TxDb.Mmusculus.UCSC.mm10.knownGene", bioc = TRUE)
installReqs("TxDb.Hsapiens.UCSC.hg19.knownGene", bioc = TRUE)
installReqs("pheatmap", bioc = TRUE)
installReqs("RColorBrewer", bioc = TRUE)
installReqs("clusterProfiler", bioc = TRUE)
installReqs("pheatmap", bioc = TRUE)
installReqs("reshape", bioc = TRUE)
installReqs("ggplot2", bioc = TRUE)
installReqs("colourpicker", bioc = TRUE)
installReqs("shinyFiles", bioc = TRUE)
installReqs("ggupset", bioc = TRUE)
