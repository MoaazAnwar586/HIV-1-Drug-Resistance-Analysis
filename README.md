# HIV-1 Drug Resistance and Phylogenetic Analysis

This repository contains R and Python scripts used in the study:

*Molecular characterization of HIV-1 and reverse transcriptase drug resistance patterns in Faisalabad, an emerging HIV hotspot in Pakistan.*

---

## Overview

The repository provides scripts used for statistical analysis, visualization of HIV-1 drug resistance patterns, mutation profiling, and phylogenetic analysis.

---

## Repository Contents

### 01_NRTI_NNRTI_Resistance_Plot.R

**Language:** R

This script generates sequence-wise resistance profile plots for NRTI and NNRTI drug resistance mutations identified in HIV-1 sequences.

### 02_CD4_ViralLoad_Statistics.R

**Language:** R

This script performs statistical analyses comparing CD4 count and viral load between ART-experienced and ART-naive participants.

**Statistical Methods**

- Median (Q1, Q3)
- Wilcoxon rank-sum test
- Summary table generation using the gtsummary package

### 03_E138A_Zerofold_Mutations.py

**Language:** Python

This script identifies and visualizes protein-changing (zero-fold) mutations within the E138A-positive subtype A cluster in the HIV-1 pol region.

### 04_IQTREE_Commands.txt

**Software:** IQ-TREE

Contains commands and parameters used for maximum-likelihood phylogenetic tree reconstruction.

---

## Software and Packages

### R Packages

- gtsummary
- ggplot2
- dplyr

### Python Packages

- pandas
- numpy
- matplotlib

### Phylogenetic Software

- IQ-TREE

---

## Reproducibility

All scripts required to reproduce the analyses and figures presented in the manuscript are provided in this repository.

---

## Author

**Muhammad Moaaz Anwar**

Department of Virology, Pakistan

---
