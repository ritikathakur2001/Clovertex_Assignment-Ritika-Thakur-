#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
  main.nf - path-only variant (NO tuple/list destructuring)
  - Input: samples.csv with host/container paths
  - Output: annotated VCFs in ./results
*/

params.samples   = params.samples ?: "${projectDir}/samples.csv"
params.outdir    = params.outdir  ?: "${projectDir}/results"
params.vep_image = params.vep_image ?: "ensemblorg/ensembl-vep:release_109.3"
params.cache_dir = params.cache_dir ?: "/opt/vep/.vep"
params.fasta     = params.fasta ?: "/opt/vep/homo_sapiens/GRCh37.primary.fa"
params.threads   = params.threads ?: 1
params.memory    = params.memory  ?: "3 GB"

// --- helper: collect vcf file paths from the CSV
def collectVcfPathsFromCsv = { csvPath ->
    def f = file(csvPath)
    if( !f.exists() ) {
        System.err.println "ERROR: samples file not found: ${csvPath}"
        System.exit(1)
    }
    def v = []
    f.text.readLines().findAll{ it?.trim() }.eachWithIndex { line, idx ->
        if ( idx == 0 && (line.toLowerCase().contains('sample') || line.toLowerCase().contains('vcf')) ) {
            // skip header
        } else {
            def cols = line.split(/,|\t/).collect{ it?.trim() }
            if ( cols.size() > 1 && cols[1] ) {
                v << cols[1]
            }
        }
    }
    return v
}

def vcf_paths = collectVcfPathsFromCsv(params.samples)
if( vcf_paths.size() == 0 ) {
    System.err.println "ERROR: No VCF file paths found in samples CSV: ${params.samples}"
    System.exit(1)
}

// build a file channel of VCF paths
vcf_ch = Channel.fromList( vcf_paths.collect { p -> file(p) } )
vcf_ch = vcf_ch.filter { f ->
    if (!f.exists()) {
        println "Warning: VCF file not found: ${f}"
        return false
    }
    return true
}

process annotate_vcf {
    tag { vcf_file.baseName }

    publishDir params.outdir, mode: 'copy', overwrite: true

    // Lower memory + single fork to fit your machine
    cpus 1
    memory '3 GB'
    time '3h'

    container params.vep_image

    input:
      path vcf_file    // channel will be bound in the workflow

    output:
      file "*.annotated.vcf.gz"

    script:
    """
    set -euo pipefail

    sample_name=\$(basename "${vcf_file}" | sed 's/\\.vcf\\(\\.gz\\)*\$//')
    outname="\${sample_name}.annotated.vcf.gz"

    echo "Running VEP on: ${vcf_file}"
    echo "Sample: \$sample_name"
    echo "Cache dir: ${params.cache_dir}"
    echo "FASTA: ${params.fasta}"

    vep \\
      -i ${vcf_file} \\
      -o \$outname \\
      --vcf \\
      --compress_output bgzip \\
      --offline \\
      --cache \\
      --dir_cache ${params.cache_dir} \\
      --fasta ${params.fasta} \\
      --force_overwrite \\
      --no_stats \\
      --fork 1

    echo "VEP done for ${vcf_file} -> \$outname"
    """
}

workflow {
    // bind the channel here
    annotate_vcf(vcf_ch)
}

workflow.onComplete {
    println "Finished pipeline. Results are in: ${params.outdir}"
}

