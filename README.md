# Clovertex_Assignment-Ritika-Thakur-
**Assignment 1: Genomics Annotation with VEP**

**Objective:-** The goal of this assignment was to annotate two given VCF files using Ensembl VEP in offline mode with a local cache and reference FASTA, and then carry out downstream analysis in Python (covered separately in a Jupyter Notebook).

**Step 1: Environment Setup**
I worked inside WSL2 with a dedicated conda environment.

Code to be run in bash:- 
conda create -n vep_env python=3.10 -y
conda activate vep_env
conda install -c bioconda ensembl-vep -y

**Step 2: Cache and FASTA Setup**
For Cache Download-
I downloaded cache file: homo_sapiens_vep_115_GRCh37.tar.gz

Code to be run in bash:-  
mkdir -p ~/.vep
mv /mnt/c/Users/Rupesh/Downloads/homo_sapiens_vep_115_GRCh37.tar.gz ~/.vep/
cd ~/.vep
tar -xvzf homo_sapiens_vep_115_GRCh37.tar.gz


This created the directory:
~/.vep/homo_sapiens/115_GRCh37/...

FASTA Reference
I used the file GRCh37.primary.fa.gz (already available from GENCODE/Ensembl).

Code to be run in bash:-
gunzip -k ~/vep_minidata/GRCh37.primary.fa.gz

**Step 3: Input File Preparation**
The input VCFs had spaces in their filenames, which caused issues. I renamed them:

Code to be run in bash:-
cd ~/Clovertex_assignment
mv "test1_data 1.vcf" test1_data_1.vcf
mv "test2_data 1.vcf" test2_data_1.vcf

**Step 4: Annotation with VEP**
I ran VEP in offline mode using the cache and FASTA.

For Test1:
Code to be run in bash:-
vep \
  -i ~/Clovertex_assignment/test1_data_1.vcf \
  -o ~/Clovertex_assignment/test1_data_annotated.vcf \
  --vcf \
  --offline \
  --cache \
  --dir_cache ~/.vep \
  --fasta ~/vep_minidata/GRCh37.primary.fa \
  --force_overwrite
  
For Test2:
vep \
  -i ~/Clovertex_assignment/test2_data_1.vcf \
  -o ~/Clovertex_assignment/test2_data_annotated.vcf \
  --vcf \
  --offline \
  --cache \
  --dir_cache ~/.vep \
  --fasta ~/vep_minidata/GRCh37.primary.fa \
  --force_overwrite

  
**Step 5: Outputs**
test1_data_annotated.vcf
test2_data_annotated.vcf
Warning logs (if any): .vcf_warnings.txt

**Screenshot of the results**
Below image showing the annotated files of both vcf
<img width="844" height="582" alt="image" src="https://github.com/user-attachments/assets/29816b22-cb05-46a1-8f93-103ed44f4b4d" />

Uploaded text log written to 'vcf_analysis_log.txt' file: D:\clovertex_assignment\test1_data_annotated_analysis\vcf_analysis_log.txt

Below image shows summary of the test1_data1 annotated vcf file
<img width="1594" height="698" alt="image" src="https://github.com/user-attachments/assets/e1c26663-5fe6-4af2-bee4-128a3f62f93b" />

<img width="1228" height="594" alt="image" src="https://github.com/user-attachments/assets/d51af351-d7da-4242-a269-d44407c204ab" />

PLots showing visual representation of the data_1test_1 annotated files details:

<img width="879" height="495" alt="image" src="https://github.com/user-attachments/assets/4ff651c5-4ee0-46d7-bcd4-a3dbcac2dc26" />

<img width="839" height="426" alt="image" src="https://github.com/user-attachments/assets/82a9fd51-31b4-4102-bd85-7b36c6253fdf" />

<img width="833" height="506" alt="image" src="https://github.com/user-
attachments/assets/0272c28c-4f40-460a-afa7-9c7659bebbf3" />

Below image shows summary of the test2_data1 annotated vcf file

<img width="789" height="45" alt="image" src="https://github.com/user-attachments/assets/b0c12d83-9ef5-454d-aef4-750f0d054a4c" />

<img width="273" height="77" alt="image" src="https://github.com/user-attachments/assets/3ed4b169-d204-41a1-9664-74a34b4ce6d8" />

Text log written to: D:\clovertex_assignment\test2_data_annotated_analysis\vcf_analysis_log.txt

PLots showing visual representation of the annotated files of test2_data2:
<img width="860" height="500" alt="image" src="https://github.com/user-attachments/assets/01e2f937-6780-480f-a6a1-8d2106a480c9" />

<img width="864" height="421" alt="image" src="https://github.com/user-attachments/assets/12eb273c-415b-42e2-ac12-81d09a855953" />

<img width="846" height="507" alt="image" src="https://github.com/user-attachments/assets/b327bd2a-f267-4c23-8bae-875ce701dd40" />


**NOTES**
I began by setting up the VEP environment and downloading the required reference files. Initially, I tried using multiple sources (FASTA, GTF, and also ClinVar as a custom annotation). However, I ran into several issues along the way — corrupted downloads, very large FASTA size taking a lot of space, and repeated version mismatches between my installed VEP (115) and the available cache.
To solve these, I verified each file with gunzip -t, used bgzip + tabix where needed, and focused on keeping only the essential files. After a few failed attempts with GTF/ClinVar, I decided to rely on the offline cache + FASTA combination, which finally gave me clean results.

The key decisions I made were:
Stick to cache + FASTA only for annotation (simpler and faster).
Re-download and validate files whenever CRC errors appeared.
Ensure the cache version exactly matched my VEP version.
Manage space carefully, since the cache and FASTA files are quite large.
# Another approach for this assignment could be to combine cache/FASTA with ClinVar or other custom annotation sources, but my final results were achieved successfully with cache + FASTA only.

# The downstream Python analysis (counts, unique genes/traits, pathogenic variants, chromosome distribution) was done in a separate Jupyter Notebook, which I will include as part of the final submission.
