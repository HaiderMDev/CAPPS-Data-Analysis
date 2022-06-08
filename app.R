
app_name    = " CAAT " 
app_version = "Version 2.0 "

#Install packages if not installed
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

#Loading packages:
library(shiny)
library(shinydashboard)
library(shinyjqui)
library(DT)
library(lintr)
library(tidyverse)
library(DiffBind)
library(BiocManager)
library(DESeq2)
library(edgeR)
library(circlize)
library(ChIPseeker)
library(org.Hs.eg.db)
library(org.Mm.eg.db)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(pheatmap)
library(RColorBrewer)
library(clusterProfiler)
library(pheatmap)
library(reshape)
library(ggplot2)
library(shinycssloaders)
library(shinyWidgets)
library(shinyjs)
library(colourpicker)
library(shinyFiles)

################# #################### #################### UI COMPONENT #################### #################### ####################
ui <- dashboardPage(
    #This is setting the title of the application
    dashboardHeader(title = paste(app_name,app_version, sep=" "), titleWidth=250),
    
    dashboardSidebar(width = 250,
                     
         tags$style(".skin-blue .sidebar 
               a { 
                  color: #444; 
               }"),
               
         tags$style(".skin-blue .sidebar 
               a.sidebarlink:link, a.sidebarlink:visited { 
                                    color: #FFF;
               }"),
         
         tags$style(".skin-blue .sidebar
                a.sidebarlink:hover {
                                    color: #777;
               }"),
               
         tags$style(".skin-blue .sidebar
                .center {
                        text-align: center;
               }"),
               
         tags$style(".skin-blue .sidebar
                .borderbox {
                        border: 2px solid #666;
                        padding: 5px 5px 5px 5px;
                        margin: 2px;
               }"),
           
           
            #Panel for data uploading sampleshet
            conditionalPanel(condition = "input.program == 'Tab1'",
               div(id = 'samplesheet page',
                   tags$div('class' = "center",
                   tags$br(),
                   h3(HTML('<b>C</b>hIP-seq and <b>A</b>TAC-seq <b>A</b>nalysis <b>T</b>ool')),
                   h5(HTML('<br><b>CAAT</b> is a tool designed for the visual analysis of <b>Ch</b>romatin <b>I</b>mmunopreci<b>P</b>itation <b>seq</b>uencing (ChIP-seq) \
                              and <b>A</b>ssay for <b>T</b>ransposase <b>A</b>ccessible <b>C</b>hromatin <b>seq</b>uencing (ATAC-seq). This tool utilizes the DiffBind and \
                              ChIPseeker packages for differential peak analysis and peak annotation, respectively.')),
                   h4(HTML('<br><b>R version 4.1.2 </b>')),
                   tags$br(),
                   tags$br(),
                   tags$br()),
                   tags$div('class'="borderbox",
                         fileInput(inputId  = "SampleSheet",
                                   label    = "Choose .csv File",
                                   multiple = FALSE,
                                   accept   = c("text/csv","text/comma-separated-values,text/plain",".csv"))
                           ),
                   
                   tags$br(),
                   tags$div('class'="borderbox",
                            #sets the header to true automatically
                            checkboxInput("header", "Header", TRUE),
                            #sets the sep parameter when uploading files into R
                            radioButtons("sep", "Separator",
                                          choices  = c(comma = ",",Semicolon = ";",Tab = "\t"),selected = ","),
                           ),
                   
                   tags$br(),
                   tags$div('class'="center",
                   #Action button to close the app
                   actionButton("close", "Close Program",
                                icon("close"),
                                style = "color: #fff; background-color: red; border-color: #fff;width:130;padding: 5px 5px 5px 5px;margin: 5px 5px 5px 5px; ")
                                     )
                                    )
                                   ),
            
           #Condition panel for choosing experimental settings
           conditionalPanel(condition = "input.program == 'Tab2'",
                           div(id = 'experimental_settings_sidebar')
                           ),
           
           #Panel for Diff bind and gene annotation plot 
           conditionalPanel(condition = "input.program == 'Tab3'",
               #HTML('A <b>B</b>rowser-based tool for the <b>E</b>xploration <b>A</b>nd <b>V</b>isualization of <b>R</b>NAseq data<br><br>'),
               div(id = 'DiffBind_sidebar',
                   
                   tags$div('class'="center", 
                            #h4(HTML('<b>Download Options</b><br>'))),
                            h3(HTML('<b>Download options</b><br>')),
                            tags$hr(),
                            tags$br(),
                            #h4(HTML('<b>Full Table</b><br>')),
                            h4(HTML('<b>Full table</b><br>')),
                            downloadButton("downloadFinalReport", 
                                           "Full Data Table (.csv)",
                                           style = "color: #fff; background-color: #27ae60; border-color: #fff;padding: 5px 14px 5px 14px;margin: 5px 5px 5px 5px; "),
                            ),
                   
                   tags$br(),
                   tags$br(),
                   tags$div('class'="center", 
                   h4(HTML('<b>Filtered Table</b><br>')),
                           ),
                   
                   tags$div('class'="borderbox",
                     tags$div('class'="center",
                            tags$h5("Positive Fold Change"),
                            downloadButton("downloadPositiveReport", 
                                           "Positive FC (.csv)",
                                           style = "color: #fff; background-color: #27ae60; border-color: #fff;padding: 5px 14px 5px 14px;margin: 5px 5px 5px 5px; "),
                            tags$h5("Negative Fold Change"),
                            downloadButton("downloadNegativeReport", 
                                           "Negative FC (.csv)",
                                           style = "color: #fff; background-color: #27ae60; border-color: #fff;padding: 5px 14px 5px 14px;margin: 5px 5px 5px 5px; "),
                            tags$h5("FDR < 0.2"),
                            downloadButton("downloadFDRReport", 
                                           "FDR < 0.2 (.csv)",
                                            style = "color: #fff; background-color: #27ae60; border-color: #fff;padding: 5px 14px 5px 14px;margin: 5px 5px 5px 5px; "),
                                          )
                                         )
                                        )
                                       ),
         
          #Panel for PCA and heatmap plot
          conditionalPanel(condition = "input.program == 'Tab4'",
              div(id = "plots_page",
                  tags$br(), tags$br(), tags$br(),
                  tags$div('class'="center", 
                     h4(HTML('<b>DiffBind Plots</b><br>')),
                     tags$div('class' = "center",
                              h5(HTML('<br>These graphs were generated using functions available in the diffbind package. A more detailed description of these plots can be \
                                          found by clicking below<br><br>')),
                              url_diffbind <- a("Diffbind Resource", href="https://bioconductor.org/packages/devel/bioc/vignettes/DiffBind/inst/doc/DiffBind.pdf"),
                              tags$br(),
                              tags$br(),
                              tags$br(),
                              tags$br()),
                           )
                          )
                        ),
         
         #Conditonal panel for gene annotation plots
         conditionalPanel(condition = "input.program == 'Tab5'",
              div(id = 'annotation',
                  conditionalPanel(condition = "input.Annot == 'Tab1'",      
                    div(id='Annotated_NO_FDR',
                        
                        tags$div('class'= "center",
                        h3(HTML('<br><br><br><b>Filtering options</b><br>')),
                               ),
                        
                         tags$div('class'="borderbox",
                           menuItem(h4(HTML('<b>OPTIONS</b><br>')),
                              radioButtons("region", "Select by Negative or Positive Fold Change",
                                             choices  = c(All = "All", NEGATIVE = "NEGATIVE", POSITIVE = "POSITIVE"), selected = "NEGATIVE"),
                              h4(HTML('<b>Filter by FDR</b><br>')),  
                              radioButtons("FDR", "Filter by FDR (Medium: 0.2 | Stringent: 0.05)",
                                           choices  = c(None = "no_FDR", Medium= "medium",Stringent = "stringent"),selected = "medium")
                                          )),
                          tags$br(),tags$br())
                                          
                        ), conditionalPanel(condition="input.Annot == 'Tab3'",
                                   div(id = 'help_page')
                                 )
                                )
                               ),
            
         #Panel for pathways analysis                            
         conditionalPanel(condition = "input.program == 'Tab6'",
            div(id = 'PATHWAYS',
             conditionalPanel(condition = "input.pathways == 'Tab1'",
                 div(id='negative',
                     tags$br(),  #introduces space
                     tags$div('class'="borderbox",
                     textInput("DisplayNumber",label=h4("Number of Pathways to Display"),width="300",value="10",placeholder="Enter a number..."),
                             ),
                     tags$br(),
                     tags$div('class'="center",
                     h3(HTML('<b>Filter by FDR value</b><br>'))
                             ),
                     
                     #FDR value 
                     tags$div('class'="borderbox",
                     menuItem("Filtering Options",
                                 radioButtons("FDRPATH", "Filter by FDR (Medium: 0.2 | Stringent: 0.05)",
                                              choices  = c(None = "none",Medium ="medium",Stringent = "stringent"),selected  = "medium")
                                 )
                                ),
                     
                     tags$br(),tags$br(),
                     tags$div('class'="center",
                     h3(HTML('<b>KEGG or REACTOME</b><br>'))
                             ),
                     
                     #Kegg or Reactome Pathways Analysis: 
                     tags$div('class'="borderbox",
                     menuItem("KEGG or REACTOME",
                           radioButtons("KEGGorREACTOME", "Choose database for pathways analysis",
                                        choices  = c(KEGG = "KEGG", REACTOME = "REACTOME", NONE = "None"),selected= "REACTOME")
                                 )
                                ),
                        tags$div('class'="center",
                           h5(HTML('<br><b>Download Table (.csv)</b><br>')),
                           downloadButton("downloadLOSTpath", 
                                          "Negative FC",
                                          style = "color: #fff; background-color: #27ae60; border-color: #fff;padding: 5px 14px 5px 14px;margin: 5px 5px 5px 5px; "),                                          
                           downloadButton("downloadGAINpath", 
                                          "Positive FC",
                                          style = "color: #fff; background-color: #27ae60; border-color: #fff;padding: 5px 14px 5px 14px;margin: 5px 5px 5px 5px; ")                                          
                                             )
                                            )
                                           ),
            
               conditionalPanel(condition = "input.pathways == 'Tab2'",
                  div(id='positive',
                     tags$br(),  #introduces space
                     tags$div('class'="center",
                         h4(HTML('<br><br><b> Controls on Previous Page </b>'))
                                 )
                                )
                               ),
               conditionalPanel(condition = "input.pathways == 'Tab3'",
                  div(id = 'help_page',
                     tags$div('class'="center",
                        h4(HTML('<b>Help Page</b>'))
                            ) 
                           )
                          )
                         )
                        ),
         
         #conditional panel for heatmap plot
         conditionalPanel(condition = "input.program == 'Tab7'",
           div(id='Annotated_Genes_Plots',
               
               tags$b("Select if you have triplicates"), 
               materialSwitch("filterTableEnabled", label = tags$b("YES!"), value = FALSE, status = "primary"),
               
               tags$div('class'="center",
                         h4(HTML('<b>Filter by FDR value</b>'))
                        ),
               
               #FDR value 
               tags$div('class'="borderbox",
               menuItem("Filtering Options",
                     radioButtons("PHEATFDR", "Filter by FDR (Medium: 0.2 | Stringent: 0.05)",
                                  choices  = c(None = "none",Medium = "medium", Stringent = "stringent"),selected  = "medium")
                        )),
               
               h4("Appearance"),
               textInput("heatmap_title", label=h4("Main Title"),width="200",value="",placeholder="Enter a title..."),
               tags$div('class'="borderbox",
                        h4("Clustering"),
                        selectInput("heatmap_clustMethod", label = "Clustering method",
                                    choices = list("Ward.D" = "ward.D", 
                                                   "Ward.D2" = "ward.D2", 
                                                   "Single" = "single", 
                                                   "Complete" = "complete", 
                                                   "Average" = "average", 
                                                   "McQuitty" = "mcquitty", 
                                                   "Median" = "median", 
                                                   "Centroid" = "centroid"),
                                    selected = 1),
                        checkboxInput("heatmap_clustRows", label = tags$b("Cluster rows"), value = TRUE),
                        checkboxInput("heatmap_clustCols", label = tags$b("Cluster columns"), value = FALSE),
                              ),
               
               tags$div('class'="borderbox",
                        numericInput("heatmap_treeHeightRows", label = "Row tree height", value = 50),
                        numericInput("heatmap_treeHeightCols", label = "Column tree width", value = 50),
                        selectInput("sampleClustering_mapColor", label = "Heatmap color",
                                    choices = list("Blues" = "Blues",
                                                   "Blue-Purple" = "BuPu",
                                                   "Green-Blue" = "GnBu",
                                                   "Greens" = "Greens",
                                                   "Greys" = "Greys",
                                                   "Oranges" = "Oranges", 
                                                   "Orange-Red" = "OrRd",
                                                   "Purple-Blue" = "PuBu",
                                                   "Purple-Blue-Green" = "PuBuGn",
                                                   "Purple-Red" = "PuRd",
                                                   "Purples" = "Purples", 
                                                   "Red-Purple" = "RdPu", 
                                                   "Reds" = "Reds", 
                                                   "Yellow-Green" = "YlGn",
                                                   "Yellow-Green-Blue" = "YlGnBu",
                                                   "Yellow-Orange-Brown" = "YlOrBr",
                                                   "Yellow-Orange-Red" = "YlOrRd"
                                                   ), selected = 1),
                              ),
                  tags$div('class'="borderbox",
                        h4("Font sizes"),
                        numericInput("heatmap_fontsize_sampleNames", label = "Sample names", value = 10),
                        numericInput("heatmap_fontsize", label = "Annotations", value = 10),                               
                               ) 
                              )
                             ),
         
         #panel for individual genes
         conditionalPanel(condition = "input.program == 'Tab8'",
              div(id='Select_Genes',
                  tags$br(),  #introduces space
                  tags$br(),
                  
                  tags$div('class'="center",
                           h4(HTML('<b>Genes Specific Plots</b>'))
                           ),
                  
                  #Text input
                  tags$div('class'="center",
                           h5(HTML('<br>You can enter multiple genes at once. Separate each gene\
                                   by comma. Importantly,When entering gene names, do not leave \
                                   any spaces after the comma. It is not necessary to italisize or capatilze.<br>'))
                           ),
                  textAreaInput("GenesSelect",label=h4("Enter Genes"),height="80",width="400",value="",placeholder="GAPDH,ACTIN,..."),
                  tags$br(),
                  tags$br(), 

                  tags$div('class'="center",
                           h5(HTML('<b>Download Shortlisted Table</b>'))
                              ),
                  tags$div('class'="center",
                  downloadButton("Download_GeneInfo", 
                                 "Download Table",
                                 style = "color: #fff; background-color: #27ae60; border-color: #fff;padding: 5px 14px 5px 14px;margin: 5px 5px 5px 5px; ")
                                )
                               )
                              ),
         
         #Acknowledgement page
         conditionalPanel(condition = "input.program == 'Tab9'",
                          div(id='acknowledgement',
                              tags$br(),  #introduces space
                              tags$br(),
                              
                              tags$div('class'="center",
                                       h3(HTML('<b>C</b>hIP-seq and <b>A</b>TAC-seq <b>A</b>nalysis <b>T</b>ool'))
                                       )
                                      )
                                     ),
         
         conditionalPanel(condition =  "input.program == 'Tab10'",
                          div(id = 'samplesheet_formation',
                              tags$br(),
                              tags$br(),
                              tags$div('class'="center",
                                       h3(HTML('<b>C</b>hIP-seq and <b>A</b>TAC-seq <b>A</b>nalysis <b>T</b>ool'))
                                      )
                                     )
                                    )
                                    
                                      
         
), #End dashboard sidebar

            
    dashboardBody(
                
               tabBox(id= "program", width=30,height=650, side = "left",title= paste(app_version),
                      
                   tabPanel(title = "Tab1", id = "Tab1", value = "Tab1",
                     HTML('<div style="padding:10px 10px 10px 10px;"><p>'),
                      tabsetPanel(
                         tabPanel(title="Sample Sheet Information", id="Tab1", value="Tab1",
                            fluidRow(
                               tags$h3("Sample Sheet Information"),
                               tags$hr(),
                               #Data table output
                               DT::dataTableOutput(outputId = "uploaded_samplesheet"),
                               #Action button to move to the start analysis page
                               actionButton("Start_Analysis", 
                                            "Differential Peak Analysis",
                                            icon("Next Page"),
                                            style = "color: #fff;background-color: #27ae60; border-color: #fff;padding: 5px 14px 5px 14px;margin: 5px 5px 5px 5px; "),
                                           )
                                          ),
                         tabPanel(title = "Help", id = "Tab2", value="Tab2",
                                  #HTML('<div style="padding:10px 10px 10px 10px;"><p>'),
                                  tags$h3("Sample Sheet Formatting Guide"),
                                  tags$hr(),
                                  tags$br(),
                                  fluidRow(
                                  tags$h4(HTML('The SampleSheet is a <b>".csv" </b> file containing the column headings listed below (A example of the SampleSheet is included in our GitHub page):')),
                                  tags$h5(HTML('<b>SampleID:</b> ID for the sample (eg. C122, TDGKO1 etc)')),
                                  tags$h5(HTML('<b>Tissue:</b> Enter cell type (eg. Hepatocytes, liver, MCF7 etc)')),
                                  tags$h5(HTML('<b>Factor: </b> Enter your samples and replicates (For instance, WT1, WT2, KO1, KO2 etc..)')),
                                  tags$h5(HTML('<b>Condition: </b> Identify your sampleID input (For instance, WT, WT, KO, KO for duplicates in wild-type and knockout)')),
                                  tags$h5(HTML('<b>Treatment: </b> List any treatments')),
                                  tags$h5(HTML('<b>Replicates: </b> Identify the replicates for your Condition entry')),
                                  tags$h5(HTML('<b>bamReads:</b> Enter the full directory for your bam files for each condition and replicate')),
                                  tags$h5(HTML('<b>Peaks: </b> Enter teh full directory for your .bed files for each condition and replicate')),
                                  tags$h5(HTML('<b>PeakCaller: </b> If you used CAPPS software, then list MACS2. Otherwise, provide the identify of whatever peak caller was used to generate .bed files')),
                                  tags$h5(HTML('<b>PeakFormat:</b> BED')),
                                  tags$h5(HTML('<b>ScoreCol: </b> 5')),
                                  tags$h5(HTML('<b>LowerBetter: </b> FALSE')),
                                  tags$h6("Please email me at hhassa3@uwo or hhassan4242@gmail.com if you require clarification.")
                                 ))
                                ),HTML('</p></div>')
                              ),
                   
                   tabPanel(title = "Tab2", id = "Tab2", value = "Tab2",
                      HTML('<div style="padding:10px 10px 10px 10px;"><p>'),
                      tabsetPanel(
                         tabPanel(title="Main Settings",id="Tab1",value="Tab1",
                                  #HTML('<div style="padding:10px 10px 10px 10px;"><p>'),
                                  tags$h3("Experimental Settings"),
                                  tags$hr(),
                                  tags$br(),
                                  tags$h5("Currently, only mouse (mm10) and human (Hg19) genomes are configured for this program!"),
                                  #select input for genome
                                  selectInput("ref_genome_organism", label = "Reference organism",
                                              choices = list("Human" = 1, "Mouse" = 2),selected = 2),
                                  
                                  #Sect the contorls and treatment
                                  uiOutput("control"),
                                  uiOutput("treatment"),
                                  #HTML('</p></div>')
                                    ),
                         tabPanel(title="Advanced Settings",id="Tab2",value="Tab2",
                                  #HTML('<div style="padding:10px 10px 10px 10px;"><p>'),
                                  tags$h3("Differential Peak Analysis Settings"),
                                  tags$hr(),
                                  tags$h4("NOTE: If changes are made to these settings, all data analysis will automaticaly re-start. Do not leave any spaces."),
                                  tags$h5("These are settings for the DiffBind package. The preset values are pre-filled. You may configure these values for your analysis"),
                                  #Select bUSESUMMARISE
                                  textInput("bUseSummarizeOverlaps",label=h5("bUseSummarizeOverlaps (TRUE/FALSE)"),width="500",value="FALSE",placeholder="FALSE"),
                                  textInput("Summits",label=h5("Summits"),width="500",value="100",placeholder="Type a number for summits..."),
                                  textInput("TH",label=h5("Select a value for FDR (0.05 - 1)"),width="300",value="1",placeholder="Type a number for FDR..."),
                                  textInput("bCounts",label=h5("bCounts Setting (TRUE/FALSE)"),width="300",value="TRUE",placeholder="TRUE"),
                                  #HTML('</p></div>')
                                 )
                               ),HTML('</p></div>')
                              ), 
                            
                   #Page where diffbind datatable output is viewed         
                   tabPanel(title = "Tab3", id = "Tab3", value = "Tab3",
                     #url for diffbind and chipseeker
                      url_diffbind <- a("Diffbind Resource", href="https://bioconductor.org/packages/devel/bioc/vignettes/DiffBind/inst/doc/DiffBind.pdf"),
                      url_chipseeker <- a("ChIPseeker Resource", href="https://bioconductor.org/packages/release/bioc/manuals/ChIPseeker/man/ChIPseeker.pdf"),
                      tags$h3("Differential Peak Analysis"),
                      tags$h5("This uses DiffBind package and ChIPseeker to perform differential accessibility and peak annotation, respectively."),
                      tags$hr(),
                      tags$h5("The user manual for diffbind can be downloaded by clicking the link here:",url_diffbind),
                      tags$h5("The user manual for ChIPseeker can be downloaded by clicking the link here:",url_chipseeker),
                      tags$br(),
                      tags$h4("Basic Summary:"),
                      p(h5("Total number of differentially enriched peaks:"), h5(textOutput(outputId="Number_of_genes",inline=TRUE)), style = "color:red"),
                      p(h5("The number of peaks with positive fold change relative to the contorl group:"), h5(textOutput(outputId="positive",inline=TRUE)),style = "color:red"),
                      p(h5("The number of peaks with negative fold change relative to the contorl group:"), h5(textOutput(outputId="negative",inline=TRUE)),style = "color:red"),
                      p(h5("The number of peaks that pass p-value cut-off of 0.05:"), h5(textOutput(outputId="pvalue",inline=TRUE))),
                      p(h5("The number of peaks that pass FDR cut-off of 0.2:"), h5(textOutput(outputId="FDR",inline=TRUE))),
                      p(h5("The number of peaks that pass p-value cut-off of 0.05 and FDR cut-off of 0.2:"), h5(textOutput(outputId="FDR_p_value",inline=TRUE))),
                      #HTML('</p></div>')
                              ),
                   
                   #Panel for PCA, Heatmap, MA and Volcano plots
                   tabPanel(title = "Tab4", id = "Tab4", value = "Tab4",
                      HTML('<div style="padding:5px 5px 5px 20px;"<p>'),
                      tabsetPanel(
                         tabPanel(title = "PCA Plot", id = "Tab1", value = "Tab1",
                            tags$h3("Principle Component Analysis (PCA) Plot"),
                            tags$hr(),
                            fluidRow(width=40,
                               dropdown(label = "Save PCA Plot",
                                  selectInput("PCAplot_dpi", label = "Output dpi", width = "95",
                                              choices = list("24 dpi" = 24, "48 dpi" = 48, "96 dpi" = 96, "192 dpi" = 192),
                                              selected = 48),
                                  downloadButton("savePCApng","PNG"),
                                  HTML('<br><br>'), #<br> creates breaks and moves item to next line
                                  downloadButton("savePCAjpg","JPG"),
                                  HTML('<br><br>'),
                                  downloadButton("savePCAtiff","TIFF"),
                                  size = "default",
                                  icon = icon("download", class = ""), 
                                  up = FALSE),
                               HTML('</p>'),
                               jqui_resizable(#jqui resizable canvass
                                 plotOutput("PCA_plot", height = "350", width = "350"),
                                             )
                                            )
                                           ),
                         tabPanel(title = "Heatmap Plot", id = "Tab2", value = "Tab2",
                            #HTML('<div style="padding:5px 5px 5px 20px;"<p>'),
                            fluidRow(width=40,
                               tags$h3("Heatmap Plot"),
                               tags$hr(),
                               dropdown(label = "Save Heatmap",
                                  selectInput("Heatmapo_dpi", label = "Output dpi", width = "95",
                                              choices = list("24 dpi" = 24, "48 dpi" = 48, "96 dpi" = 96, "192 dpi" = 192),
                                              selected = 48),
                                  downloadButton("saveHEATpng", "PNG"),
                                  HTML('<br><br>'), #<br> creates breaks and moves item to next line
                                  downloadButton("saveHEATjpg", "JPG"),
                                  HTML('<br><br>'),
                                  downloadButton("saveHEATtiff", "TIFF"),
                                  size = "default",
                                  icon = icon("download", class = ""), 
                                  up   = FALSE),
                               HTML('</p>'),
                               jqui_resizable(#jqui resizable canvass
                                  plotOutput("HEATo_plot", height = "350", width = "350")
                                             )#,HTML('</div>')
                                            )
                                          ),
                         tabPanel(title = "MA Plot", id = "Tab3", value = "Tab3",
                            #HTML('<div style="padding:5px 5px 5px 20px;"<p>'),
                            tags$h3("MA Plot"),
                            tags$hr(),
                            fluidRow(width=40,
                               dropdown(label = "Save MA Plot",
                                  selectInput("MAplot_dpi", label = "Output dpi", width = "95",
                                              choices = list("24 dpi" = 24, "48 dpi" = 48, "96 dpi" = 96, "192 dpi" = 192),
                                              selected = 48),
                                  downloadButton("saveMApng", "PNG"),
                                  HTML('<br><br>'), #<br> creates breaks and moves item to next line
                                  downloadButton("saveMAjpg", "JPG"),
                                  HTML('<br><br>'),
                                  downloadButton("saveMApdf", "PDF"),
                                  HTML('<br><br>'),
                                  downloadButton("saveMAtiff", "TIFF"),
                                  size = "default",
                                  icon = icon("download", class = ""), 
                                  up = FALSE),
                               HTML('</p>'),
                               jqui_resizable(
                                  #tagList(
                                  #HTML('<div style="border:1.5px solid grey;padding:5px 5px 0px 0px;width:5;background-color: #FFFFFF;float:left;display:block;"><p>'),
                                  plotOutput("MA_plot", height = "300", width = "360"),
                                  #HTML('</p></div>')
                                              )
                                             )
                                            ),
                         tabPanel(title = "Volcano Plot", id = "Tab4", value = "Tab4",
                            tags$h3("Volcano Plot "),
                            tags$hr(),
                            fluidRow(width=40,
                                     
                               dropdown(label = "Save Volcano Plot",
                                  selectInput("VOLCANO_plot_dpi", label = "Output dpi", width = "95",
                                              choices = list("24 dpi" = 24, "48 dpi" = 48, "96 dpi" = 96, "192 dpi" = 192),
                                              selected = 48),
                                  downloadButton("saveVOLCANOpng", "PNG"),
                                  HTML('<br><br>'), #<br> creates breaks and moves item to next line
                                  downloadButton("saveVOLCANOjpg", "JPG"),
                                  HTML('<br><br>'),
                                  downloadButton("saveVOLCANOpdf", "PDF"),
                                  HTML('<br><br>'),
                                  downloadButton("saveVOLCANOtiff", "TIFF"),
                                  size = "default",
                                  icon = icon("download", class = ""), 
                                  up = FALSE),
                               HTML('</p>'),
                               jqui_resizable(
                                  plotOutput("VOLCANO_plot", height = "300", width = "360"),
                                        )
                                       )
                                      )
                                     ),HTML('</p></div>')
                                    ),
                   
                   #Panel for Gene annotation Plots
                   tabPanel(title = "Tab5", id = "Tab5", value = "Tab5",
                     HTML('<div style="padding:5px 5px 5px 20px;"<p>'),
                      tabsetPanel(id="Annot",
                         tabPanel(title = "No FDR Correct", id = "Tab1", value = "Tab1",
                            tags$h3("Gene Annotation Without FDR Correction"),
                            tags$hr(),
                            fluidRow(width=40,
                               dropdown(label = "Download Plot",
                                  selectInput("AnnotatedGenesFDR_dpi", label = "Output dpi", width = "95",
                                              choices = list("24 dpi" = 24, "48 dpi" = 48, "96 dpi" = 96, "192 dpi" = 192),
                                              selected = 48),
                                  downloadButton("saveANNOTATEDFDRpng", "PNG"),  
                                  HTML('<br><br>'), #<br> creates breaks and moves item to next line
                                  downloadButton("saveANNOTATEDFDRjpg", "JPG"),
                                  HTML('<br><br>'),
                                  downloadButton("saveANNOTATEDFDRpdf", "PDF"),
                                  HTML('<br><br>'),
                                  downloadButton("saveANNOTATEDFDRtiff", "TIFF"),
                                  size = "default",
                                  icon = icon("download", class = ""), 
                                  up = FALSE
                                       ),
                               HTML('</p>'),
                               jqui_resizable(
                                  plotOutput("AnnotatedGenesFDR_plot", height = "300", width = "360"),
                                          )
                                         )
                                        ),
                         tabPanel(title="Help",id="Tab2",value="Tab2",
                                  tags$h2("Help Page"),
                                  tags$hr(),
                                  tags$h4("General Guidelines"),
                                  tags$h5("The graph on the first page is not corrected for FDR. This page is to determine rough overall enrichment for peaks between control and treatment condition without any filtering by FDR or p-value"),
                                  tags$h5("The graph on the second page can be corrected for FDR. The FDR value can be adjusted from none (i.e FDR = 1) to stringent (FDR < 0.05)."),
                                  tags$h5("The peaks were annotated using the ChIPseeker package."),
                                  tags$br(),
                                  tags$h4("For ATAC-seq:"),
                                  tags$h5("For ATAC-seq analysis, the negative and positive fold change cannotates regions that are losing or gaining  accessibiility relative to the contorl group, respectively."),
                                  tags$br(),
                                  tags$h4("For ChIP-seq:"),
                                  tags$h5("For ChIP-seq analysis, the negative and positive fold changes cannotates a decrease or increase in peak enrichment relative to the control group, respectively."),
                                  tags$br()          
                                   )
                                  ),HTML('</p></div>')
                                 ),
                                     
                   #Panel for Pathways Analysis
                   tabPanel(title = "Tab6", id = "Tab6", value = "Tab6",
                      HTML('<div style="padding:5px 5px 5px 20px;"<p>'),
                      tabsetPanel(id="pathways",
                         tabPanel(title = "Negative Fold Change", id = "Tab1", value = "Tab1",
                            tags$h3("Gene Annotation Without FDR Correction"),
                            tags$hr(),
                            fluidRow(width=40,
                               dropdown(label = "Negative Fold Change",
                                   selectInput("LOST_dpi", label = "Output dpi", width = "95",
                                               choices = list("24 dpi" = 24, "48 dpi" = 48, "96 dpi" = 96, "192 dpi" = 192),
                                               selected = 48),
                                   downloadButton("saveLOSTpng", "PNG"),
                                   HTML('<br><br>'), #<br> creates breaks and moves item to next line
                                   downloadButton("saveLOSTjpg", "JPG"),
                                   HTML('<br><br>'),
                                   downloadButton("saveLOSTpdf", "PDF"),
                                   HTML('<br><br>'),
                                   downloadButton("saveLOSTtiff", "TIFF"),
                                   size = "default",
                                   icon = icon("download", class = ""), 
                                   up = FALSE),
                               HTML('</p>'),
                               jqui_resizable(
                                  plotOutput("LOST_plot", height = "250", width = "360"),
                                             )
                                            )
                                           ),
                            tabPanel(title = "Positive Fold Change", id = "Tab2", value = "Tab2",
                               tags$h3("Pathways Analysis"),
                               tags$hr(),
                               fluidRow(width=40,
                                  dropdown(label = "Positive Fold Change",
                                     selectInput("GAIN_dpi", label = "Output dpi", width = "95",
                                                 choices = list("24 dpi" = 24, "48 dpi" = 48, "96 dpi" = 96, "192 dpi" = 192),
                                                 selected = 48),
                                     downloadButton("saveGAINpng", "PNG"),
                                     HTML('<br><br>'), #<br> creates breaks and moves item to next line
                                     downloadButton("saveGAINjpg", "JPG"),
                                     HTML('<br><br>'),
                                     downloadButton("saveGAINpdf", "PDF"),
                                     HTML('<br><br>'),
                                     downloadButton("saveGAINtiff", "TIFF"),
                                     size = "default",
                                     icon = icon("download", class = ""), 
                                     up = FALSE),
                                  HTML('</p>'),
                                  jqui_resizable(
                                     plotOutput("GAIN_plot", height = "250", width = "360"),
                                                )
                                               )
                                              ),
                            tabPanel(title="Help",id="Tab3",value="Tab3",
                                     tags$h2("Help Page"),
                                     tags$hr(),
                                     tags$h4("General Guidelines"),
                                     tags$h5("The graph on the left and right represent pathways analysis for regions undergoing a negative and positive fold change relative to the control group, respectively."),
                                     tags$h5("The peaks were annotated using the ChIPseeker package and pathways analysis can be performed using the KEGG or REACTOME databases."),
                                     tags$br(),
                                     tags$h4("For ATAC-seq:"),
                                     tags$h5("For ATAC-seq analysis, the negative and positive fold change cannotates regions that are losing or gaining  accessibiility relative to the contorl group, respectively."),
                                     tags$br(),
                                     tags$h4("For ChIP-seq:"),
                                     tags$h5("For ChIP-seq analysis, the negative and positive fold changes cannotates a decrease or increase in peak enrichment relative to the control group, respectively."),
                                     tags$br()          
                                        )
                                       ),HTML('</p></div>')
                                      ),
                   
                   #Panel for heatmap panel
                   tabPanel(title = "Tab7", id = "Tab7", value = "Tab7",
                      #layout HTML tags
                      HTML('<div style="padding:5px 5px 5px 20px;"><p>'),
                      tags$h3("Heatmap"),
                      tags$h5("This uses the pheatmap package in R to generate heaptmaps"),
                      tags$br(),
                      fluidRow(width = 40, 
                         #layout HTML tags. <p> represents a paragraph
                         #the div is used as a container for html elements
                         #HTML('<div style="padding:5px 5px 5px 20px;"<p>'),
                         # download button
                         dropdown(label = "Heatmap", #label of the button
                            selectInput("HEATMAPFinal_dpi", label = "Output dpi", width = "95",
                                        choices = list("24 dpi" = 24, "48 dpi" = 48, "96 dpi" = 96, "192 dpi" = 192),
                                        selected = 48),
                            downloadButton("saveHEATMAPpng", "PNG"),
                            HTML('<br><br>'), #<br> creates breaks and moves item to next line
                            downloadButton("saveHEATMAPjpg", "JPG"),
                            HTML('<br><br>'),
                            downloadButton("saveHEATMAPpdf", "PDF"),
                            HTML('<br><br>'),
                            downloadButton("saveHEATMAPtiff", "TIFF"),
                            size = "default",
                            icon = icon("download", class = ""), 
                            up = FALSE),
                         HTML('</p>'),
                         jqui_resizable(
                            plotOutput("HEATMAP_plot", height = "300", width = "450"),
                                        )
                                       ),HTML('</p></div>')
                                      ),
                   
                   #Panel for gene specific plots panel
                   tabPanel(title = "Tab8", id = "Tab8", value = "Tab8",
                      HTML('<div style="padding:5px 5px 5px 20px;"><p>'),
                      tabsetPanel(id = "genespecific",
                        tabPanel(title="Gene Specific Plot", id = "Tab1", value= "Tab1",
                            tags$h3("Gene Specific Plots"),
                            tags$br(),
                            fluidRow(width = 40, 
                               #layout HTML tags. <p> represents a paragraph
                               #the div is used as a container for html elements
                               #HTML('<div style="padding:5px 5px 5px 20px;"<p>'),
                               # download button
                               dropdown(label = "Genes",
                                  selectInput("GeneSpecific_dpi", label = "Output dpi", width = "95",
                                              choices = list("24 dpi" = 24, "48 dpi" = 48, "96 dpi" = 96, "192 dpi" = 192),
                                              selected = 48),
                                  downloadButton("saveGenespng", "PNG"),
                                  HTML('<br><br>'), #<br> creates breaks and moves item to next line
                                  downloadButton("saveGenesjpg", "JPG"),
                                  HTML('<br><br>'),
                                  downloadButton("saveGenestiff", "TIFF"),
                                  size = "default",
                                  icon = icon("download", class = ""), 
                                  up = FALSE),
                               HTML('</p>'),
                               jqui_resizable(
                                  plotOutput("GeneSpecific_plot", height = "300", width = "360"),
                                              )
                                             )
                                            ),
                        tabPanel(title = "Help", id = "Tab2", value = "Tab2",
                           tags$h1("Help with gene plot"),
                           tags$hr(),
                           tags$h6("When entering the gene names, you get the plot of fold change of treatment enrichment values subtracted from control values"),
                                 )
                                ),HTML('</p></div>')
                               ),
                   #Tab for acknowledgment
                   tabPanel(title="Tab9", id="Tab9", value="Tab9",
                            HTML('<div style="padding:5px 5px 5px 5px;"><p>'),
                            tags$h1("Acknowledgement"),
                            tags$hr(),
                            tags$br(),
                            tags$h4("This software simplifies and streamlines the analysis of ATAC-seq or ChIP-seq analysis in R."),
                            tags$h4("This package incorporates the DiffBind and ChIPseeker package for differential peak analysis and peak annotation, respectively."),
                            tags$br(),
                            tags$h4("Heatmap was generated using the pheatmap package. The gene-specific plots were generated using ggplot2."),
                            tags$h4("This software was designed using the R Shinny package. "),
                            tags$br(),
                            tags$br(),
                            tags$h4("Please cite this software in your publication. If any questions, please contact me at hhassan4242@gmail.com. Thank you!"),
                            #HTML('</div>'),          #
                            HTML('</p></div>')
                                            ),
                   #---------- PAGE TO FETCH DIRECTORIES ----------#
                  # tabPanel(title="Tab10", id="Tab10", value="Tab10",
                   #         HTML('<div style="padding:5px 5px 5px 5px;"><p>'),
                     #       tags$h1("Sample Sheet Formation"),
                    #        tags$hr(),
                  #          tags$br(),
                   #         fluidRow(column(width=1,
                    #                    h5(HTML('<b>SampleID</b>')),
                  #                  textInput("Sample1",label=h6(""),width="70",value="",placeholder="C1"),
                     #                  textInput("Sample2",label=h6(""),width="70",value="",placeholder="C1"),
                      #                  textInput("Sample3",label=h6(""),width="70",value="",placeholder="C1"),
                       #                 textInput("Sample4",label=h6(""),width="70",value="",placeholder="C1"),
                                  #   ),
                                     
                               #      column(width=1,
                                #         h5(HTML('<b>BAM READS</b>')),
                                 #        textOutput(outpudId=test, ),
                                  #       shinyFilesButton('BAM1', 'File select', 'Please select a file', FALSE),
                                   #      verbatimTextOutput("filechosen")
                                    # ),
                                     #column(width=1,
                                      #      h5(HTML('<b>BED READS</b>')),
                                     #)
                                     #),HTML('</p></div>')
                                      #      ),
                   
                   #Java script for recording mouse input into list_tabs
                   tags$script("
                               $('body').mouseover(function() {
                                list_tabs=[];
                                $('#program li a').each(function(){
                                  list_tabs.push($(this).html())
                                     });
                                  Shiny.onInputChange('List_of_tab', list_tabs);})"
                                 )
                                ),
               
                     #output for the next, previous buttons
                     uiOutput("Next_Previous")
               
),#end dashboardBody
       
                     skin = "blue"

) #end dashboard page 


            
               
#################### #################### SERVER COMPONENT #################### ####################
shinyServer <- function(input, output, session) {
   # ---- DATA UPLOAD / input --------- #
   #reading in the user input and saving it as samples
   samplesheet <- reactive({
       req(input$SampleSheet)
       samples <- read.csv(input$SampleSheet$datapath,
                           header = input$header,
                           sep    = input$sep)
       return(samples)
    }
   )
   
   
   #---------- FUNCTION TO FETCH DIRECTORIES ----------#
   #shinyFileChoose(input, 'BAM1', root = c(root = '/Users/'),          
    #               filetypes = c('', "bam"))
   
   #file <- reactive(input$files)
   #output$filechosen <- renderText({
      #as.character(parseFilePaths(c(home = "/home/guest/test_data"),file())$datapath)
      # Either is fine
      # parseFilePaths(c(home = "/home/guest/test_data"),file())$datapath,stringAsFactors=F)
   #})
   
#}   
   #---------- FUNCTION TO FETCH DIRECTORIES ----------#
   
   
   #---------- Render UI for Experimental Settings ----------#
   #Get BAM file information from samplesheet:
   output$control <- renderUI({
       samplesheet <- samplesheet()
       subset <- samplesheet %>% select(Condition)
       selectInput("control", "Choose Control Condition", subset, selected = subset[1]) #select first unique output (which is WT)
    }
   )
   
   output$treatment <-renderUI ({
       samplesheet <- samplesheet()
       subset <- samplesheet %>% select(Condition)
       selectInput("treatment", "Choose Treatment Condition", subset, selected = subset[1]) #select second unique output (which is KO)
    }
   )
   
   
   #--------------- Begin Analysis ---------------#
   ######################################################
   #Perform the functions by diffbind:
   #At first, I am going to stop at diffbind.analyze becasuse i need this 
   #for MA and volcano plots. If I do it this way and then call the dbaAnalyze
   #whenever I need, I don't have to keep repeating the analayze steps which takes forever!
   #Excellent trick!
   
   ########### INDIVIDUAL STEPS BROKEN DOWN ###############
   dbaAnalyze <- reactive ({
       #Import the samplesheet and store it as "samples"
       samples <- samplesheet()
       #Add ProgressBar
       total_steps  = 18
       current_step = 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Initializing...."))
       #perform the diffbind analysis steps 
       dba <- dba(sampleSheet = samples)
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Converting to dba matrix."))
       count <- dba.count(dba,summits=strtoi(input$Summits),bUseSummarizeOverlaps = toupper(input$bUseSummarizeOverlaps))
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating count matrix."))
       contrast <- dba.contrast(count, categories=DBA_CONDITION, minMembers=2)
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Performing contrast..."))
       analyze <- dba.analyze(contrast,method=DBA_ALL_METHODS)
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Analyzing...."))
       #store analyze
       return(analyze)
   }
   )
   
   #Generating final report
   diffbind <- reactive ({
       #Import the analyze from above and store it as "analyze"
       analyze <- dbaAnalyze()
       #Add progressBar
       total_steps  = 3
       current_step = 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Initializing...."))
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Analyzing...."))
       final_report <- dba.report(analyze,th=strtoi(input$TH),bCounts=toupper(input$bCounts))
       #Convert final report to data frame:
       final <- as.data.frame(final_report)
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating table of differentially bound regions..."))
       #return the final_report data frame
       return(final)
   }
   )
   
   #Annotating the GeneList
   geneAnno <- reactive({
       total_steps  = 20
       current_step = 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Initializing...."))
       #reading in the finalreport
       finalReport <- diffbind()
       dataframe <- as.data.frame(finalReport)
       current_step = current_step + 2
       incProgress(current_step/total_steps*100,
                   detail = paste("Loading genome and annotation files..."))
       #subselecting the genomic locations:
       #genomic_location <- dataframe[,1:3]
       write.table(dataframe,"peakfile.txt",sep="\t")
       current_step = current_step + 2
       incProgress(current_step/total_steps*100,
                   detail = paste("Writing peaks...."))
       #reading peak file
       peak <-readPeakFile("peakfile.txt")
       current_step = current_step + 2
       incProgress(current_step/total_steps*100,
                   detail = paste("Annotating peaks..."))
       #KnownGene files loading
       mtxdb = TxDb.Mmusculus.UCSC.mm10.knownGene #mouse
       htxdb = TxDb.Hsapiens.UCSC.hg19.knownGene  #human
       #annotating peaks
       #1: human
       #2: mouse 
       if (input$ref_genome_organism == 1) {
           peakAnno <- annotatePeak(peak,
                                    tssRegion=c(3000,3000),
                                    TxDb = htxdb,
                                    annoDb="org.Hs.eg.db")
       } else if (input$ref_genome_organism == 2) {
           peakAnno <- annotatePeak(peak,
                                    tssRegion=c(3000,3000),
                                    TxDb = mtxdb,
                                    annoDb="org.Mm.eg.db")
       }
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("All finished..."))
       return(peakAnno)
   }
   )
   
   
   ################## Frame 3 Information ###################
   output$Number_of_genes <- renderText({
       withProgress(message = 'Performing calculations....',
                    value = 1, min = 1, max = 100,{
                        #Load the geneAnno
                        annot <- geneAnno()
                        annot2 <- as.data.frame(annot)
                        Number <-nrow(annot2)
                        return(Number)
                        #paste(h4("The number of called peaks:"),"<font color=\"#FF0000\"><b>", h4(Number), "</b></arial>")
                    }
       )
   }
   )
   #Positive Fold change
   output$positive <- renderText({
       #Load the geneAnno
       annot <- geneAnno()
       annot2 <- as.data.frame(annot)
       pvalue <-annot2[which(annot2$Fold > 0),]
       Number <- nrow(pvalue)
       return(Number)
   }
   )
   #Negative Fold Change:
   output$negative <- renderText({
       #Load the geneAnno
       annot <- geneAnno()
       annot2 <- as.data.frame(annot)
       pvalue <-annot2[which(annot2$Fold < 0),]
       Number <- nrow(pvalue)
       return(Number)
   }
   )
   #p-value
   output$pvalue <- renderText({
       #Load the geneAnno
       annot <- geneAnno()
       annot2 <- as.data.frame(annot)
       pvalue <-annot2[which(annot2$p.value <= 0.05),]
       Number <- nrow(pvalue)
       return(Number)
   }
   )
   #q-value
   output$FDR <- renderText({
       #Load the geneAnno
       annot <- geneAnno()
       annot2 <- as.data.frame(annot)
       pvalue <-annot2[which(annot2$FDR <= 0.2),]
       Number <- nrow(pvalue)
       return(Number)
   }
   )
   #both
   output$FDR_p_value <- renderText({
       #Load the geneAnno
       annot <- geneAnno()
       annot2 <- as.data.frame(annot)
       pvalue <-annot2[which(annot2$FDR <= 0.2 & annot2$p.value <= 0.05),]
       Number <- nrow(pvalue)
       return(Number)
   }
   )
   
   
   ################## FILTERING ###################
   #Filtering by, FDR, closed and open regions, and genes for ATACseq using the reactive table from above:
   annot_diffAcc <- reactive({
       #Load in the annotated region and diffbound file called annot
       annot <- geneAnno()
       annot2 <- as.data.frame(annot)
       #Merge the two tables together
       #fullTable <- merge(finalReport,annot,by="seqnames",all=T)
       #filterTable<-fullTable[which(fullTable$FDR < 1),]
       if (input$region == "All") {
           filter_table <<- annot2
       } else if (input$region == "NEGATIVE") {
           filter_table = annot2[which(annot2$Fold < 0),]
       } else if (input$region == "POSITIVE") {
           filter_table = annot2[which(annot2$Fold > 0),]
       } 
       #return filter_table
       return(filter_table)
   }
   )
   
   #Filter the annotated genelist by FDR for piechart analysis:
   FDR_filter <- reactive({
       #Load in the filter Table file:
       annot2 <- annot_diffAcc()
       #filter the table based upon user input FDR value
       if (input$FDR == "no_FDR") {
           filtered <- annot2
       } else if (input$FDR == "medium") {
           filtered = annot2[which(annot2$p.value < 0.2),]
       } else if (input$FDR == "stringent") {
           filtered = annot2[which(annot2$p.value < 0.05),]
       }
       #return FDR filtered table
       return(filtered)
   }
   )
   
   #Filter the annotated genelist by FDR for pathways analysis:
   FDR_filter_PATH <- reactive({
       #Load in the filter Table file:
       annot <- geneAnno()
       annot2 <- as.data.frame(annot)
       #filter the table based upon user input FDR value
       if (input$FDRPATH == "no_FDR") {
           filtered <- annot2
       } else if (input$FDRPATH == "medium") {
           filtered = annot2[which(annot2$p.value < 0.2),]
       } else if (input$FDRPATH == "stringent") {
           filtered = annot2[which(annot2$p.value < 0.05),]
       }
       #return FDR filtered table
       return(filtered)
   }
   )
   
   #Pre-heatmap table selection if customer is using tripicates or duplicates:
   dup_or_trip <- reactive({
       #read in annotated diffbound output
       annot <- geneAnno()
       annot2 <- as.data.frame(annot)
       #filter based on triplicates or duplicates:
       if (input$filterTableEnabled == "TRUE") {
           #Filter the table based upon radio button input
           filter_table <<- annot2[, c(12,13,31,14:19)]
       } else {
           filter_table <<- annot2[,c(12,13,28,14:17)]
       }
       #return the filtered table
       return(filter_table)
   }
   )
   
   #Filter heatmap table by FDR value
   heatmap_table <- reactive({
       #read in annotated diffbound output
       df <- dup_or_trip()
       #filtering:
       if (input$PHEATFDR == "none") {
           filtered <- df
       } else if (input$PHEATFDR == "medium") {
           filtered = df[which(df$p.value < 0.2),]
       } else if (input$PHEATFDR == "stringent") {
           filtered = df[which(df$p.value < 0.05),]
       }
       #return FDR filtered table
       return(filtered)
   }
   )
   
   #----DATATABLES for open region pathways analysis -----#
   gain_path <- reactive({
       filter_table <- FDR_filter_PATH()
       filter_table_gain <- filter_table[which(filter_table$Fold > 0),]
       #select entrez ID:
       entrezids <- filter_table_gain$geneId %>% 
           as.character() %>% 
           unique()
       #do GO analysis based upon USER input:
       #1: human
       #2: mouse 
       if (input$ref_genome_organism == 1) {
           if (input$KEGGorREACTOME == "KEGG") {
               ego <- enrichKEGG(gene = entrezids,
                                 organism = 'hg',
                                 pvalueCutoff = 0.2)
           } else if (input$KEGGorREACTOME == "REACTOME") {
               ego <- enrichGO(gene = entrezids, 
                               keyType = "ENTREZID", 
                               OrgDb = org.Hs.eg.db, 
                               ont = "BP", 
                               pAdjustMethod = "BH", 
                               qvalueCutoff = 0.2, 
                               readable = TRUE)
           }
       } else if (input$ref_genome_organism == 2) {
           if (input$KEGGorREACTOME == "KEGG") {
               ego <- enrichKEGG(gene = entrezids,
                                 organism = 'mmu',
                                 pvalueCutoff = 0.2)
           } else if (input$KEGGorREACTOME == "REACTOME") {
               ego <- enrichGO(gene = entrezids, 
                               keyType = "ENTREZID", 
                               OrgDb = org.Mm.eg.db, 
                               ont = "BP", 
                               pAdjustMethod = "BH", 
                               qvalueCutoff = 0.2, 
                               readable = TRUE)
           }
       }
       #return the ego
       return(ego)
      }
     )
   #Generate Table. Top code can be used for graph
   GainPath_Table <- reactive ({
       GainPath <<- gain_path()
       cluster_summary <- data.frame(GainPath)
       return(cluster_summary)
   }
   )
   
   lost_path <- reactive({
       filter_table <- FDR_filter_PATH()
       filter_table_gain <- filter_table[which(filter_table$Fold < 0),]
       #select entrez ID:
       entrezids <- filter_table_gain$geneId %>% 
           as.character() %>% 
           unique()
       #do GO analysis based upon USER input:
       #1: human
       #2: mouse 
       sort_gene_list <-sort(entrezids,decreasing=TRUE)
       
       if (input$ref_genome_organism == 1) {
           if (input$KEGGorREACTOME == "KEGG") {
               ego <- enrichKEGG(gene = entrezids,
                                 organism = 'hg',
                                 pvalueCutoff = 0.2)
           } else if (input$KEGGorREACTOME == "REACTOME") {
               ego <- enrichGO(gene = entrezids, 
                               keyType = "ENTREZID", 
                               OrgDb = org.Hs.eg.db, 
                               ont = "BP", 
                               pAdjustMethod = "BH", 
                               qvalueCutoff = 0.2, 
                               readable = TRUE)
           }
       } else if (input$ref_genome_organism == 2) {
           if (input$KEGGorREACTOME == "KEGG") {
               ego <- enrichKEGG(gene = entrezids,
                                 organism = 'mmu',
                                 pvalueCutoff = 0.2)
           } else if (input$KEGGorREACTOME == "REACTOME") {
               ego <- enrichGO(gene = entrezids, 
                               keyType = "ENTREZID", 
                               OrgDb = org.Mm.eg.db, 
                               ont = "BP", 
                               pAdjustMethod = "BH", 
                               qvalueCutoff = 0.2, 
                               readable = TRUE)
           }
          }
       #return the ego
       return(ego)
   }
   )
   #Convert ego to table
   LossPath_Table <- reactive ({
       LossPath <<- lost_path()
       cluster_summary <- data.frame(LossPath)
       return(cluster_summary)
   }
   )
   
   #Datatables for GSEA and CNE plot
   gain_path_GSEA_CNE <- reactive ({
      filter_table <- FDR_filter_PATH()
      filter_table_gain <- filter_table[which(filter_table$Fold > 0),]
      #select entrez ID:
      entrezids <- filter_table_gain$geneId %>% 
         as.character() %>% 
         unique()
      #do GO analysis based upon USER input:
      #1: human
      #2: mouse 
      
   })
   
   ######GETTING FOLD CHANGES FOR INPUT GENES ADDED TO INPUT##########
   #Processing input added to textAreaInput
   genesselect <- reactive ({
       genestomap <<- unlist(strsplit(toupper(input$GenesSelect),","))
       #colnames(genestomap)<-c("number","genes")
       return(genestomap)
   }
   )
   #Filtering the annotated diffbind table based on "genestomap"
   genesubset <- reactive ({
       annot  <- geneAnno()
       annot2 <- as.data.frame(annot)
       genestomap  <- genesselect()
       #Convert gene names to uppercase:
       annot3 <<- data.frame(lapply(annot2, function(x) {
           if (is.character(x)) 
               return(toupper(x))
           else return(x)
       }
       )
       )
       filtered <<- filter(annot3,annot3$SYMBOL %in% genestomap)
       return(filtered)
   }
   )
   
   #Getting data ready for ggplot barplot which is reactive
   genes_ggplot<- reactive({
       dataframe <- genesubset()
       subset <- dataframe %>% select(SYMBOL,Fold)
       df1     <- melt(subset,"SYMBOL")
       return(df1)
   }
   )
   ######END OF TEXT INPUT CODE##########
   
   
   #------------------ PLOTS ----------------- #
   #PCA Plot generated using diffbind
   output$PCA_plot = renderPlot({
       withProgress(message = 'Rendering PCA Plot...', value=1, min=1,max=100, {
           do_PCA_plot()
       }
       )
   }
   )
   do_PCA_plot <- reactive({
       samples <- samplesheet()
       #Add ProgressBar
       total_steps  = 2
       current_step = 1
       #perform the diffbind analysis steps 
       dba <- dba(sampleSheet = samples)
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Converting to dba matrix."))
       #PCA Plot
       dba.plotPCA(dba, attributes=DBA_CONDITION, label=DBA_ID)
   }
   )
   
   #HeatMap generated using diffbind:
   output$HEATo_plot = renderPlot({
       withProgress(message = 'Rendering Heatmap Plot...', value=1, min=1,max=100, {
           do_HEATo_plot()
       }
       )
   }
   )
   do_HEATo_plot <- reactive ({
       samples <- samplesheet()
       #Add ProgressBar
       total_steps  = 2
       current_step = 1
       #perform the diffbind analysis steps 
       dba <- dba(sampleSheet = samples)
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating heatmap."))
       #plot heatmap
       p = dba.plotHeatmap(dba)
       print(p)
   }
   )
   
   #MA plot using diffbind
   output$MA_plot = renderPlot({
       withProgress(message = 'Rendering MA Plot...', value=1, min=1,max=100, {
           do_MA_plot()
       }
       )
   }
   )
   #MA Plot
   do_MA_plot <- reactive({
       analyze <- dbaAnalyze()
       #Add ProgressBar
       total_steps  = 15
       current_step = 1
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Converting to dba matrix."))
       #MA Plot
       dba.plotMA(analyze, bNormalized=FALSE)
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating MA Plot...."))
   }
   )
   
   #Volcano Plot:
   output$VOLCANO_plot <- renderPlot({
       withProgress(message = 'Rendering Volcano Plot...', value=1, min=1,max=100, {
           do_VOLCANO_plot()
       }
       )
   }
   )
   do_VOLCANO_plot <- reactive ({
       analyze <- dbaAnalyze()
       #Add ProgressBar
       total_steps  = 2
       current_step = 1
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating volcano plot"))
       #plot volcano
       dba.plotVolcano(analyze)
   }
   )
   
   #The annotated genelist plot for PIE CHART
   output$AnnotatedGenes_plot <- renderPlot({
       withProgress(message = 'Rendering Plot...', value=1, min=1,max=100, {
           do_AnnotatedGenes_plot()
       }
       )
   }
   )
   do_AnnotatedGenes_plot <- reactive({
       total_steps  = 20
       current_step = 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Initializing...."))
       #Load in the file and subselect columns for processing
       filter_table <- annot_diffAcc()
       filter_table2 <- filter_table[,1:3]
       write.table(filter_table2,"filter_table2.txt",sep="\t")
       #KnownGene files loading
       mtxdb = TxDb.Mmusculus.UCSC.mm10.knownGene #mouse
       htxdb = TxDb.Hsapiens.UCSC.hg19.knownGene  #human
       incProgress(current_step/total_steps*100,
                   detail = paste("Loading genome and annotation files..."))
       #subselecting the genomic locations:
       current_step = current_step + 2
       incProgress(current_step/total_steps*100,
                   detail = paste("Writing peaks...."))
       #reading peak file
       peak <-readPeakFile("filter_table2.txt")
       current_step = current_step + 2
       incProgress(current_step/total_steps*100,
                   detail = paste("Annotating peaks..."))
       #annotating peaks
       #1: human
       #2: mouse 
       if (input$ref_genome_organism == 1) {
           peakAnno <- annotatePeak(peak,
                                    tssRegion=c(3000,3000),
                                    TxDb = htxdb,
                                    annoDb="org.Hs.eg.db")
       } else if (input$ref_genome_organism == 2) {
           peakAnno <- annotatePeak(peak,
                                    tssRegion=c(3000,3000),
                                    TxDb = mtxdb,
                                    annoDb="org.Mm.eg.db")
       }
       plotAnnoPie(peakAnno)
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("All finished..."))
   }
   )
   
   #Filter annotated plot by FDR for PIE CHART
   output$AnnotatedGenesFDR_plot <- renderPlot({
       withProgress(message = 'Rendering Plot...', value=1, min=1,max=100, {
           do_AnnotatedGenes_FDR_plot()
       }
       )
   }
   )
   do_AnnotatedGenes_FDR_plot <- reactive({
       total_steps  = 20
       current_step = 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Initializing FDR correction...."))
       #Load in the file and subselect columns for processing
       filter_table <- FDR_filter()
       filter_table3 <- filter_table[,1:3]
       write.table(filter_table3,"filter_table3.txt",sep="\t")
       #KnownGene files loading
       mtxdb = TxDb.Mmusculus.UCSC.mm10.knownGene #mouse
       htxdb = TxDb.Hsapiens.UCSC.hg19.knownGene  #human
       incProgress(current_step/total_steps*100,
                   detail = paste("Loading genome and annotation files..."))
       #subselecting the genomic locations:
       current_step = current_step + 2
       incProgress(current_step/total_steps*100,
                   detail = paste("Writing peaks...."))
       #reading peak file
       peak <-readPeakFile("filter_table3.txt")
       current_step = current_step + 2
       incProgress(current_step/total_steps*100,
                   detail = paste("Annotating peaks and doing FDR correction..."))
       #annotating peaks
       #1: human
       #2: mouse 
       if (input$ref_genome_organism == 1) {
           peakAnno <- annotatePeak(peak,
                                    tssRegion=c(3000,3000),
                                    TxDb = htxdb,
                                    annoDb="org.Hs.eg.db")
       } else if (input$ref_genome_organism == 2) {
           peakAnno <- annotatePeak(peak,
                                    tssRegion=c(3000,3000),
                                    TxDb = mtxdb,
                                    annoDb="org.Mm.eg.db")
       }
       plotAnnoPie(peakAnno)
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("All finished..."))
   }
   )
   
   #Pathways analysis plot for regions GAINING accessibility:
   output$GAIN_plot <- renderPlot({
       withProgress(message = 'Performing Pathways Analysis ...', value=1, min=1,max=100, {
           do_GAIN_Pathways()
       }
       )
   }
   )
   do_GAIN_Pathways <- reactive ({
       ego <- gain_path()
       total_steps  = 3
       current_step = 1
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating pathways analysis plot"))
       #plot the GO pathway analysis:
       dotplot(ego, showCategory = strtoi(input$DisplayNumber))
   }
   )
   
   #Pathways analysis plot for regions LOSING accessibility (KEGG):
   output$LOST_plot <- renderPlot({
       withProgress(message = 'Performing Pathways Analysis ...', value=1, min=1,max=100, {
           do_LOST_Pathways()
       }
       )
   }
   )
   do_LOST_Pathways <- reactive ({
       ego <- lost_path()
       #Add ProgressBar
       total_steps  = 3
       current_step = 1
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating pathways analysis plot"))
       dotplot(ego, showCategory=strtoi(input$DisplayNumber))
   }
   )
   
   #heatmap output:
   output$HEATMAP_plot <- renderPlot ({
       withProgress(message = 'Rendering Heatmap ...', value=1, min=1,max=100, {
           do_HEATMAP()
             }
            )
         }
       )
   do_HEATMAP <- reactive ({
       dataframe <- heatmap_table()
       #select columns:
       df <- dataframe[,4:ncol(dataframe)]
       #get genenames
       heatmap_genenames = na.omit(dataframe, cols = c("SYMBOL"))
       genenames<- heatmap_genenames %>% select(SYMBOL)
       #scale dataframe
       s_df <- scale(df)
       #Add ProgressBar
       total_steps  = 2
       current_step = 1
       current_step = current_step + 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating heatmap"))
       #define color for heatmap
      
       col <- colorRampPalette( rev(brewer.pal(9, paste(input$sampleClustering_mapColor))) )(255)
       #graph the heatmap:
       pheatmap(s_df,
                scale="row",
                clustering_method = input$heatmap_clustMethod,
                #heights for rows and columns
                treeheight_row = input$heatmap_treeHeightRows,
                treeheight_col = input$heatmap_treeHeightCols,
                cluster_rows = input$heatmap_clustRows, 
                cluster_cols = input$heatmap_clustCols,
                #splits column in 2 based upon clustering
                cutree_cols = 2,
                #heatmap title
                main= input$heatmap_title,
                #color
                col=col,
                #font sizes
                fontsize = input$heatmap_fontsize, # general
                fontsize_col = input$heatmap_fontsize_sampleNames, #for sample names
                #gene annotation:
                cellheight=0.1,
                cellwidth=20,
                show_rownames=FALSE,
                show_colnames=TRUE)
            }
           )
   
   #Genes Specific output:
   #barplot
   output$GeneSpecific_plot <- renderPlot({
       withProgress(message = 'Rendering Boxplot ...', value=1, min=1,max=100, {
           do_geneplot()
       }
       )
   }
   )
   do_geneplot <- reactive ({
       #progress bar:
       total_steps  = 2
       current_step = 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating plots...."))
       #load in the df1
       df1 <- genes_ggplot()
       # subset <- dataframe %>% select(SYMBOL,Fold)
       #ggplot
       #df1     <- melt(subset,"SYMBOL")
       #define barplot:
       barplot <- ggplot(df1, aes(x = SYMBOL, y = value)) +
           geom_bar(aes(fill=variable),stat="identity", position ="dodge") + 
           theme_bw()+ 
           theme(axis.text.x = element_text(angle=-40, hjust=.1)) 
       #Graph barplot:
       barplot
   }
   )
   output$GeneSpecific2_plot <- renderPlot({
       withProgress(message = 'Rendering Boxplot ...', value=1, min=1,max=100, {
           do_geneplot2()
       }
       )
   }
   )
   #boxplot
   do_geneplot2 <- reactive ({
       #progress bar:
       total_steps  = 2
       current_step = 1
       incProgress(current_step/total_steps*100,
                   detail = paste("Generating plots...."))
       #load in the df1
       df1 <- genes_ggplot()
       #do box plot:
       g2 <- ggplot(df1, aes(x = SYMBOL, y=value)) + 
           geom_boxplot(notch = TRUE, varwidth = TRUE, outlier.colour = "red", outlier.shape = 1) 
       g2
   }
   )
   
   #------------------ DT DATA TABLES VISUALIZATION ----------------- #
   #Visualizing the data table in the dashboard body. I 
   #created a box in ui which has the outputID of "uploaded_samplesheet"
   #and I am putting the samplesheet defined above in that box
   output$uploaded_samplesheet = DT::renderDataTable ({
       samplesheet <- samplesheet()
       samplesheet},
       options = list(scrollX=T, scrollY=T) 
   )
   
   #Visualizing the final_report data frame from diffbind and ChIPseeker combined. 
   output$analyzed_data = DT::renderDataTable ({
       withProgress(message = 'Performing calculations....',
                    value = 1, min = 1, max = 100,{
                        finalReport <- geneAnno()
                        dataframe <- as.data.frame(finalReport)
                        dataframe
                    }
       )
   },server=FALSE,selection="single",options=list(scrollX=T, scrollY=T)
   )
   
   #------------------- DOWNLOAD BUTTONS for .csv files-----------------# 
   #Download the  reports data table:
   output$downloadFinalReport <- downloadHandler(
       filename = function() {paste("Full_Annotated_Table.csv")},
       content  = function(file){
           write.csv({finalReport<-geneAnno() 
           dataframe = as.data.frame(finalReport)
           dataframe},
           file, row.names=FALSE)
       }
   )
   #Positive
   output$downloadPositiveReport <- downloadHandler(
       filename = function() {paste("Positive_Fold_Change.csv")},
       content  = function(file){
           write.csv({annot <- geneAnno()
           annot2 <- as.data.frame(annot)
           annot3 <-annot2[which(annot2$Fold > 0),]
           annot3},
           file, row.names=FALSE)
       }
   )
   #Negative
   output$downloadNegativeReport <- downloadHandler(
       filename = function() {paste("Negative_Fold_Change.csv")},
       content  = function(file){
           write.csv({annot <- geneAnno()
           annot2 <- as.data.frame(annot)
           annot3 <-annot2[which(annot2$Fold < 0),]
           annot3},
           file, row.names=FALSE)
       }
   )
   #FDR
   output$downloadFDRReport <- downloadHandler(
       filename = function() {paste("FDR_cutOFF.csv")},
       content  = function(file){
           write.csv({annot <- geneAnno()
           annot2 <- as.data.frame(annot)
           annot3 <-annot2[which(annot2$FDR < 0.2),]
           annot3},
           file, row.names=FALSE)
       }
   )
   
   
   
   output$downloadGeneReport <- downloadHandler(
       filename = function() {paste("AnnotatedGenelist.csv")},
       content = function(file){
           write.csv({ anno <- geneAnno()
           anno
           }, file,row.names=FALSE)
       }
   )
   
   #pathways analysis for genes gaining accessibility
   output$downloadGAINpath <-downloadHandler(
       filename=function() {paste("Pathways_PositiveFC.csv")},
       content =function(file) { 
           write.csv({gain <- GainPath_Table()
           gain
           }, file, row.names=T)
       }
   )
   
   #pathways analysis for genes losing accessibility
   output$downloadLOSTpath <-downloadHandler(
       filename=function() {paste("Pathways_NegativeFC.csv")},
       content =function(file) { 
           write.csv({ lost <- LossPath_Table()
           lost
           }, file, row.names=T)
       }
   )
   
   #Download Data Table for specific genes that are selected in Tab 9
   output$Download_GeneInfo <-downloadHandler(
       filename=function() {paste("GeneInfo.csv")},
       content =function(file) { 
           write.csv({  dataframe <- genesubset()
           dataframe
           }, file, row.names=T)
       }
   )
   
   
   
   #------------------ SAVE AS FUNCTIONS FOR PLOTS-----------------#  
   
   #--------- START PCA PLOT SAVE AS FUNCTIONS -----------# 
   # png
   output$savePCApng <- downloadHandler(
       filename = function() {paste0("PCA_plot", '.png')},
       content = function(file) {
           png(file, 
               width = session$clientData[["output_PCA_plot_width"]], 
               height = session$clientData[["output_PCA_plot_height"]])
           print(do_PCA_plot())
           dev.off()
       }
   )
   
   # jpg
   output$savePCAjpg <- downloadHandler(
       filename = function() { paste0("PCA_plot", '.jpg') },
       content = function(file) {
           jpeg(file, 
                width = session$clientData[["output_PCA_plot_width"]], 
                height = session$clientData[["output_PCA_plot_height"]])
           print(do_PCA_plot())
           dev.off()
       })
   # tiff
   output$savePCAtiff <- downloadHandler(
       filename = function() { paste0("PCA_plot", '.tiff') },
       content = function(file) {
           tiff(file, 
                width = session$clientData[["output_PCA_plot_width"]], 
                height = session$clientData[["output_PCA_plot_height"]])
           print(do_PCA_plot())
           dev.off()
       })
   ### END PCA PLOT SAVE AS FUNCTIONS ###
   
   
   #---------  heatmap PLOT SAVE AS FUNCTIONS -----------# 
   # png
   output$saveHEATpng <- downloadHandler (
       filename = function() {paste0("heatmap_samples",'.png')},
       content  = function(file) {
           png(file, 
               width  = session$clientData[["output_HEATo_plot_width"]], 
               height = session$clientData[["output_HEATo_plot_width"]])
           print(do_HEATo_plot())
           dev.off()
       }
   )
   
   
   # jpg
   output$saveHEATMAPojpg <- downloadHandler(
       filename = function() {paste0("heatmap_plot",'.jpg')},
       content = function(file) {
           jpeg(file, 
                width  = session$clientData[["output_HEATo_plot_width"]], 
                height = session$clientData[["output_HEATo_plot_height"]])
           print(do_HEATo_plot())
           dev.off()
       })
   
   # tiff
   output$saveHEATMAPotiff <- downloadHandler(
       filename = function() { paste0("heatmap_plot", '.tiff') },
       content = function(file) {
           tiff(file, 
                width = session$clientData[["output_HEATo_plot_width"]], 
                height = session$clientData[["output_HEATo_plot_height"]])
           print(do_HEATo_plot())
           dev.off()
       })
   ### END Heatmap PLOT SAVE AS FUNCTIONS ###
   
   
   #--------- START MA PLOT SAVE AS FUNCTIONS -----------# 
   # png
   output$saveMApng <- downloadHandler(
       filename = function() {paste0("MA_diffbind", '.png')},
       content = function(file) {
           png(file, 
               width = session$clientData[["output_MA_plot_width"]], 
               height = session$clientData [["output_MA_plot_height"]])
           print(do_MA_plot())
           dev.off()
       })
   
   # jpg
   output$saveMApg <- downloadHandler(
       filename = function() { paste0("MA_diffbind", '.jpg') },
       content = function(file) {
           jpeg(file, 
                width = session$clientData[["output_MA_plot_width"]], 
                height = session$clientData[["output_MA_plot_height"]])
           print(do_MA_plot())
           dev.off()
       })
   
   # pdf
   output$saveMApdf <- downloadHandler(
       filename = function() { paste0("MA_diffbind", '.pdf') },
       content = function(file) {
           pdf(file, 
               width = session$clientData[["output_MA_plot_width"]]/as.integer(input$Heatmap_dp), 
               height = session$clientData[["output_MA_plot_height"]]/as.integer(input$Heatmap_dp))
           print(do_MA_plot())
           dev.off()
       })
   
   # tiff
   output$saveMAtiff <- downloadHandler(
       filename = function() { paste0("MA_diffbind", '.tiff') },
       content = function(file) {
           tiff(file, 
                width = session$clientData[["output_MA_plot_width"]], 
                height = session$clientData[["output_MA_plot_height"]])
           print(do_MA_plot())
           dev.off()
       })
   ### END MA PLOT SAVE AS FUNCTIONS ###
   
   #--------- START Volcano PLOT SAVE AS FUNCTIONS -----------# 
   # png
   output$saveVOLCANOpng <- downloadHandler(
       filename = function() {paste0("VOLCANO_plot", '.png')},
       content = function(file) {
           png(file, 
               width = session$clientData[["output_VOLCANO_plot_width"]], 
               height = session$clientData [["output_VOLCANO_plot_height"]])
           print(do_VOLCANO_plot())
           dev.off()
       })
   
   # jpg
   output$saveVOLCANOpg <- downloadHandler(
       filename = function() { paste0("VOLCANO_plot", '.jpg') },
       content = function(file) {
           jpeg(file, 
                width = session$clientData[["output_VOLCANO_plot_width"]], 
                height = session$clientData [["output_VOLCANO_plot_height"]])
           print(do_VOLCANO_plot())
           dev.off()
       })
   
   # pdf
   output$saveVOLCANOpdf <- downloadHandler(
       filename = function() { paste0("VOLCANO_plot", '.pdf') },
       content = function(file) {
           pdf(file, 
               width = session$clientData[["output_VOLCANO_plot_width"]]/as.integer(input$VOLCANO_plot_dpi), 
               height = session$clientData[["output_VOLCANO_plot_height"]]/as.integer(input$VOLCANO_plot_dpi))
           print(do_VOLCANO_plot())
           dev.off()
       })
   
   # tiff
   output$saveVOLCANOtiff <- downloadHandler(
       filename = function() { paste0("VOLCANO_plot", '.tiff') },
       content = function(file) {
           tiff(file, 
                width = session$clientData[["output_VOLCANO_plot_width"]], 
                height = session$clientData[["output_VOLCANO_plot_height"]])
           print(do_VOLCANO_plot())
           dev.off()
       })
   ### END Heatmap PLOT SAVE AS FUNCTIONS ###
   #------------------ Previous and next buttons  ----------------- #
   #Previous and next buttons in dashboard body:
   Previous_Button=tags$div(actionButton("Prev_Tab",HTML('
  <div class="col-sm-4"><i class="fa fa-angle-double-left fa-2x"></i></div>')))
   
   Next_Button=div(actionButton("Next_Tab",HTML('
  <div class="col-sm-4"><i class="fa fa-angle-double-right fa-2x"></i></div>')))
   
   output$Next_Previous=renderUI({
       div(column(1,offset=1,Previous_Button),column(1,offset=8,Next_Button))
         })
      observeEvent(input$Prev_Tab,
                {
                    tab_list=input$List_of_tab
                    current_tab=which(tab_list==input$program)
                    updateTabsetPanel(session,"program",selected=tab_list[current_tab-1])
                })
   observeEvent(input$Next_Tab,
                {
                    tab_list=input$List_of_tab
                    current_tab=which(tab_list==input$program)
                    updateTabsetPanel(session,"program",selected=tab_list[current_tab+1])
                })
   
   #This is with relation to start analysis button in tabpanel 1
   observeEvent(
       input$Start_Analysis, {
           updateTabsetPanel(session = session, 
                             inputId = "program", 
                             selected = "Tab3")
       }
   )
   #This is with relations to the action button "close"
   #This will end the session and close the app. 
   observeEvent(
       input$close, {
           stopApp()
       }
   )
   observeEvent(input$controller, {
       updateTabsetPanel(session, "program",
                         selected = paste0("Tab", input$controller)
       )
   }
   )
}


shinyApp(ui = ui, server = shinyServer)
