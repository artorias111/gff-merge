#!/usr/bin/env nextflow

process mergeGffGt {

    publishDir '.', mode: 'copy'
    input:
    path braker_gff
    path repeat_gff


    output:
    path "${params.species_id}.braker.eg.combined.gff", emit :merged_gff


    script:
    """
    awk -f ${projectDir}/fix_gff_attrs.awk ${repeat_gff} | \
    awk 'NR == 1 && !/^##gff-version 3/ { print "##gff-version 3" } { print }' > repeat.fixed.gff

    ${params.gt_path}/gt gff3 -sort -addids no ${braker_gff} repeat.fixed.gff > ${params.species_id}.braker.eg.combined.gff
    """
}


process AnnotationSketch { 
    
    publishDir '.', mode: 'copy'
    
    input:
    path merged_gff
    val genome_region

    output:
    path "${params.species_id}.annotation_sketch.png"


    script:
    def coordinate_list = genome_region.split(":")

    def chr = coordinate_list[0]
    def start = coordinate_list[1].toInteger()
    def end = coordinate_list[2].toInteger()

    if (end < start) {
        (end, start) = [start, end]
    }

    """
    ${params.gt_path}/gt sketch -seqid ${chr} -start ${start} -end ${end} ${params.species_id}.annotation_sketch.png ${merged_gff}

    """

}


workflow {
    if (!params.species_id) exit 1, "Please provide a --species_id"

    if (params.runMode == 'default') {
        braker_ch = file(params.braker_gff)
        repeat_ch = file(params.repeat_gff)

        mergeGffGt(braker_ch, repeat_ch)

        if (params.genome_region) {
            AnnotationSketch(mergeGffGt.out.merged_gff, params.genome_region)
        }
    }

    if (params.runMode == 'plot') {
        AnnotationSketch(params.gff, params.genome_region)
    }
}
