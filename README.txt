Project Name: Drought-reliefs and Partisanship

Authors: F. Boffa, F. Cavalcanti, C. Fons-Rosen, A. Piolatto

## Introduction

This README file provides detailed instructions for replicating the results of the empirical analysis presented in the paper "Drought-reliefs and Partisanship". The package includes data files and code to run the analysis. The code generates tables and figures in the paper.

## Files Organization

The replication package includes two main folders: "build" and "analysis". The "build" folder contains the data files used in the analysis. The "analysis" folder contains the code to run the analysis and generate the tables and figures.

## Analysis

To replicate the results, please follow these steps:

1. Download and extract the replication package to a folder of your choice.
2. Open the code file (Main_analysis.do) located in the folder (.\analysis\code) using your preferred Stata software.
3. Set the working directory to the folder where the replication package has been extracted.
4. Change the path to the main analysis folder specified at line 14 in the code file to the directory where the replication package is located.
5. Install any required packages specified at lines 36-47 in the code file.
6. Run the Main_analysis.do do-file to generate the results. The output files (both in png and tex format) will be saved automatically in the folder (.\analysis\output).

## Build

This folder contains all the data files necessary to reproduce the analysis. It includes:

- `.build` folder: This folder contains the raw data used in the analysis and the Stata do-file routines that clean and merge the data.
  * `input` subfolder: This subfolder contains the raw data files used in the analysis.
    - `census2000.dta`: This file contains data from the Brazilian Census of 2000 conducted by IBGE.
    - `cru_droughts_shortrun_by_cycle_1yr.dta`: This file contains data from the Climate Research Unit at the University of East Anglia on droughts in Brazil.
    - `s2id_all.dta`: This file contains data from the Sistema Integrado de Informações sobre Desastres Naturais (S2ID).
    - `tse_mayor.dta`: This file contains data from the Tribunal Superior Eleitoral (TSE).
    - `brazilian_municipalities.dta`: This file contains fixed information on Brazilian municipalities from the IBGE.
    - `distance_river.dta`: This file contains information about the geographic distance of rivers to Brazilian municipalities from Natural Earth.
    - `gini_census_2000.dta`: This file contains information on inequality in Brazilian municipalities from the 2000 IBGE CENSUS.
    - `media_radio_munic_2006.dta`: This file contains information on the presence of radios in the municipalities in the 2006 IBGE MUNIC municipal survey.
    - `pam_agricultural_production_fisher_index.dta`: This file contains information on the Fischer index adjusted for agricultural production in municipalities in Brazil based on PAM data.
    - `share_gdp_agriculture.dta`: This file contains information on the participation of agriculture in the GDP of municipalities in Brazil based on IBGE data.
  * `code` subfolder: This subfolder contains the Stata do-file routines used to clean and merge the raw data files and save the output to the "output" subfolder. To replicate the routine and generate the central database used in the study, open the `Main_build.do` routine and adjust the information about the path of the folder on your computer in line 14, and then run the code on Stata. The result generates a `main_database.dta` database in the `./build/output` folder.
  * `output` subfolder: This subfolder contains the cleaned and merged data file generated by the Stata do-file routines: `main_database.dta`. This data set will feed the analysis routines in the folder `.\analysis`.
  * `tmp` subfolder: This subfolder is an auxiliary folder used during the data cleaning and merging process.

Note: The replication package assumes that the necessary software is installed on your computer to run the analysis.

## Contact

If you have any questions or issues replicating the analysis, please contact the authors via [GitHub repository](https://github.com/FranciscoCavalcanti/Drought-reliefs-and-Partisanship) by raising an ISSUE.