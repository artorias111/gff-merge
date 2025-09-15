#!/usr/bin/env nextflow

process mergeGff {

    publishDir '.', mode: 'copy'

    input:
    path braker_gff
    path repeat_gff


    output:
    path "${params.species_id}.braker.eg.combined.gff"


    script:
    """
    touch write_file
    grep "^#" ${braker_gff} >> write_file || true
    grep "^#" ${repeat_gff} >> write_file || true

    cat ${braker_gff} ${repeat_gff} | sort -k1,1 -k4,4n >> write_file

    mv write_file ${params.species_id}.braker.eg.combined.gff
    """
}

workflow {
    if (!params.species_id) exit 1, "Please provide a --species_id"
    if (!params.braker_gff) exit 1, "Please provide a --braker_gff file"
    if (!params.repeat_gff) exit 1, "Please provide a --repeat_gff file"

    braker_ch = file(params.braker_gff)
    repeat_ch = file(params.repeat_gff)

    mergeGff(braker_ch, repeat_ch)
}
