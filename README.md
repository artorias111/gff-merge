# GFF Merge

A Snakemake workflow for merging two GFF files while preserving headers and sorting the combined data.

## Overview

This workflow combines two GFF files by:
1. Taking headers from the first file (braker.gff)
2. Merging all non-header data from both files
3. Sorting the combined data by chromosome first, and and position (START)
4. Outputs a single merged GFF file

## Usage

### Basic Usage

The workflow expects input files named with the pattern `{sample}.braker.gff` and `{sample}.earlgrey.gff`:

```bash
# Run with sample name "Dmaw12"
snakemake Dmaw12.combined.sorted.gff
```

This will look for:
- `Dmaw12.braker.gff` (input file 1)
- `Dmaw12.earlgrey.gff` (input file 2)

And produce:
- `Dmaw12.combined.sorted.gff` (merged output)

### File Preparation

Before running, ensure your input files are named correctly:
```bash
# Rename your files to match the expected pattern
mv braker.gff Dmaw12.braker.gff
mv earlgrey.gff Dmaw12.earlgrey.gff
```

### Running the Workflow

```bash
# Dry run to see what will be executed
snakemake --dry-run Dmaw12.combined.sorted.gff

# Execute the workflow
snakemake Dmaw12.combined.sorted.gff

# Run with multiple cores
snakemake -j 4 Dmaw12.combined.sorted.gff
```

## Output

The merged GFF file will contain:
- All header lines (starting with `##`) from the braker file
- All data lines from both input files, sorted by:
  - Chromosome (column 1)
  - Position (column 4)

## Requirements

- Snakemake 