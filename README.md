AI Assistance Declaration: I used ChatGPT (GPT-6, October 22, 2026) for documentation structure, Markdown wording, R Markdown formatting suggestions, and reflection drafting. Prompts used: see Appendix.md. I will verify outputs using GitHub Markdown preview, RStudio/Posit Cloud rendering, independent review of the example script, and a self spot-check. All final calculations are done by myself. I am responsible for the accuracy and originality of this work.

# Synthetic Student Performance Analysis in R

**Author:** Gunel Jafarova  
**Course:** BDA400 — Data Science Tools and Techniques  
**Date:** October 22, 2026

## Overview

This small educational project demonstrates how to document a reproducible R workflow using a **synthetic** student-performance dataset. It describes an example R script that creates fictional student records, prints numeric summaries of study hours and scores, and creates a scatter plot. No real student information is used.

## Project Objectives

- Demonstrate a clear README and R Markdown documentation workflow.
- Describe the inputs, transformations, and outputs of a basic R analysis.
- Practice reviewing AI-assisted documentation rather than accepting it without checking.

## Repository Structure

```text
markdown-buddy-gunel-jafarova/
├── README.md
├── student_analysis.R
├── student_analysis_documentation.Rmd
├── Reflection.md
└── Appendix.md
```

## Requirements and Installation

Install a current version of R and optionally RStudio or Posit Cloud. This example uses **base R only** for analysis; the R Markdown document requires the `rmarkdown` package to render.

```r
install.packages("rmarkdown")
```

## Synthetic Data and Inputs

The script creates six fictional records internally with three fields: `student_id` (fictional identifier), `study_hours` (numeric), and `score` (numeric, 0–100). No external file or personal data is required.

## Example Usage

From an R console in the repository directory:

```r
source("student_analysis.R")
```

To render the documentation to HTML, after installing R Markdown:

```r
rmarkdown::render("student_analysis_documentation.Rmd")
```

## Outputs

The script prints a small synthetic dataset, a summary of numeric columns, and a scatter plot of study hours against scores. These are illustrative outputs; the sample does not establish a causal relationship.

## Validation and Limitations

A static review confirmed the README file references match the package and the R Markdown chunks match the example script. This does **not** replace executing R or previewing on GitHub.

Review the code and values manually, run the script in R, knit the `.Rmd`, and check the rendered README on GitHub. The synthetic sample is too small for meaningful statistical generalization. **Verification status:** these external application checks must be completed by the student.

## License

Educational example for BDA400 coursework. No open-source license has been granted; reuse requires permission from the author.

## AI Assistance Disclosure

- **Tool:** OpenAI ChatGPT, GPT-6, used October 22, 2026.
- **Actual prompts:** requested a submission package on October 22, 2026, then requested an issue review and corrections. The full actual requests and illustrative instructor prompts are distinguished in `Appendix.md`.
- **Draft revisions made:** corrected the overview to describe internally generated data; identified the exact R script and base-R dependencies; added the limitations and explicit verification status.
- **Verification:** pending manual GitHub preview and RStudio/Posit Cloud rendering; do not treat AI review as a substitute for these checks.
