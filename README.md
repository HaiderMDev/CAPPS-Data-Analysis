## **C**hIP-seq and **A**TAC-seq **A**nalysis **T**ool (CAAT)

This is a program for the analysis of ATAC-seq or ChIP-seq data in R. This package incorporates the following core packages for data analysis and visualization:
```
DiffBind
ChIPseeker
Clusterprofiler 
Ggplot2 
Pheatmap 
```
&nbsp;
&nbsp;
&nbsp;

## Table of Contents
1. [Installation](#installation-and-launching-shiny-dashboard)
2. [Sample Sheet Preparation](#sample-file-preparation)

&nbsp;
&nbsp;
&nbsp;

### **Installation and Launching Shiny Dashboard**
---------------------
The **app.R** can be downloaded and opened in R-studios. Please download the **_Required_Packages.R_** file and run it, which will attempt to automatically install the required packages. 

>  Ensure you have R version 4.1.2 or higher for compatibility. 

&nbsp;
&ensp;
&nbsp;
&ensp;

### **Run shiny dashboard through terminal**

1. Open Terminal and maneuver to the directory containing the `Required_Packages.R` and `app.R` files. Type the following command:

> R < Required_Packages.R --no-save


2. Wait for the installation of required packages to complete. Then type the following command in the terminal:

> Rscript -e 'library(methods); shiny::runApp("app.R", launch.browser = TRUE)'


3. This should launch the shiny dashboard app in the browser. 



**_A docker container will be available soon for easy installation and running of the software_**

&nbsp;
&ensp;
&nbsp;
&ensp;

### **Sample File Preparation**
---------------------

The sample file contains metadata on the following main items:

 1. Sample name and identification
 2. Condition (i.e. control sample and Sample with a treatment)
 3. Location of the binary assignment file (BAM)
 4. Location of the tab-delimted text file containing feature tracks
 
 **_A pre-filled sample file is included in the GitHub page for reference. Additionally, an empty template is also included in the page. _**
 
&nbsp;
&ensp;
&nbsp;
&ensp; 
 
### **Steps to Data Analysis**
---------------------
 **The following series of steps will outline the ways that CAPPS can be used for ChIP-seq or ATAC-seq data analysis.**

> Before using CAPPS, please ensure that you run the `Required_Packages.R` file which will attempt to install packages that may be missing. 

&nbsp;
&ensp;
&nbsp;
&ensp;

#### **Step 1: Load the Sample Sheet**
---------------------








