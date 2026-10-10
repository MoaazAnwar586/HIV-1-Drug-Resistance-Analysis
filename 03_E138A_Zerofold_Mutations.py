from Bio import AlignIO
from Bio.Data import CodonTable
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# -------------------------
# Load codon-aligned FASTA
# -------------------------
aln = AlignIO.read("A_E138A.fas", "fasta")

# Check codon alignment
if aln.get_alignment_length() % 3 != 0:
    raise ValueError("Alignment is NOT codon-aligned (length not multiple of 3)")

table = CodonTable.unambiguous_dna_by_name["Standard"]

# -------------------------
# Function: detect 0-fold site
# -------------------------
def is_zero_fold(codon, pos):
    codon = codon.upper()
    if len(codon) != 3 or any(base not in "ATGC" for base in codon):
        return False

    aa = table.forward_table.get(codon)
    if aa is None:
        return False

    for base in ["A", "T", "G", "C"]:
        if base == codon[pos]:
            continue
        mutated = list(codon)
        mutated[pos] = base
        mutated = "".join(mutated)
        aa_mut = table.forward_table.get(mutated)
        if aa_mut == aa:
            return False

    return True

# -------------------------
# Find variable 0-fold sites
# -------------------------
zero_fold_positions = []

for i in range(0, aln.get_alignment_length(), 3):
    ref_codon = str(aln[0].seq[i:i+3])

    for pos in range(3):
        if is_zero_fold(ref_codon, pos):
            column = [rec.seq[i+pos] for rec in aln]
            if len(set(column)) > 1:
                zero_fold_positions.append(i + pos)

# -------------------------
# Build a numeric dataframe: 1 means the sequence differs from the reference
# -------------------------
matrix = []
reference = str(aln[0].seq).upper()
for rec in aln:
    sequence = str(rec.seq).upper()
    row = [int(sequence[p] != reference[p]) for p in zero_fold_positions]
    matrix.append(row)

df = pd.DataFrame(
    matrix,
    index=[rec.id for rec in aln],
    columns=[f"Pos_{p+1}" for p in zero_fold_positions]
)

# -------------------------
# Plot heatmap
# -------------------------
sns.heatmap(
    df,
    cmap=["#f8eee9", "#800010"],
    cbar=False,
    linewidths=0.5,
    linecolor="white"
)

# Main heading ka font size
plt.title(
    "0-fold (Protein-changing) Mutations in HIV-1 pol",
    fontsize=20,
    fontweight="bold"
)

# X-axis heading ka font size
plt.xlabel(
    "Genomic Positions",
    fontsize=16,
    fontweight="bold"
)

# Y-axis heading ka font size
plt.ylabel(
    "Sequences",
    fontsize=16,
    fontweight="bold"
)

# X-axis positions ka font size
plt.xticks(
    fontsize=11,
    rotation=90
)

# Y-axis sequence names ka font size
plt.yticks(
    fontsize=12,
    rotation=0
)

plt.tight_layout()
plt.savefig("Figure_Zerofoldmutations_A_E138A.png", dpi=300, bbox_inches="tight")
plt.show()
