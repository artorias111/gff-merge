#!/usr/bin/env nextflow

process mergeGff {

    publishDir '.', mode: 'copy'

    input:
    path braker_gff
    path eg_gff


    output:
    path "${params.species_id}.braker.eg.combined.gff"


    script:
    """
    touch write_file
    grep "^#" ${braker_gff} >> write_file
    grep "^#" ${eg_gff} >> write_file

    cat ${braker_gff} ${eg_gff} | grep -v "^#" | sort -k1,1 -nk 4,4

    mv write_file ${params.species_id}.braker.eg.combined.gff
    """
}

workflow {
    mergeGff(params.braker_gff, params.repeats_gff)
}
