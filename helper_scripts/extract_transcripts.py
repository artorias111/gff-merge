#!/usr/bin/env python3
# Check readme for the input format (expected as a .csv file)

import subprocess
import argparse
parser = argparse.ArgumentParser()
parser.add_argument('--csv', type = str, required = True) # path to csv
args = parser.parse_args()


csv_file = args.csv

line_ctr = 0 # line counter

with open(csv_file) as file:
    for line in file:
        line_ctr += 1
        if line_ctr == 1: # skip the header line
            continue
        f = line.strip()
        current_list = f.split(",")

        species_id = current_list[0]
        braker_gff_path = current_list[1]
        braker_aa_path = current_list[2]
        chr = current_list[3]
        start = current_list[4]
        end = current_list[5]


        shell_command = f"""
        awk '$1 == "{chr}" {{print $0}}' {braker_gff_path} | \
        awk '$3 == "mRNA" {{print $0}}' | \
        awk '$4>={start} && $5<={end} {{print $0}}' | \
        cut -f 9 | \
        cut -f 1 -d ";" | \
        sed 's/^ID=//' | \
        while read line; do samtools faidx {braker_aa_path} "$line"; done > {species_id}.afgp_region_transcripts.fa
        """

        # execute your flashy new shell command
        try:
        # The 'run' function executes the command
            result = subprocess.run(
            shell_command, 
            shell=True, 
            check=True, 
            capture_output=True, 
            text=True
        )
            print("Extracted successfully for", species_id)

        except subprocess.CalledProcessError as e:
            print(f"An error occurred while running the command.")
            print(f"Return code: {e.returncode}")
            print(f"Output (stdout):\n{e.stdout}")
            print(f"Error (stderr):\n{e.stderr}")
