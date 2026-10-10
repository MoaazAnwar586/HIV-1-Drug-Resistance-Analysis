# install.packages(c("tidyverse","readxl","janitor","ggbeeswarm"))  # if needed

library(tidyverse)
library(readxl)
library(janitor)
library(ggbeeswarm)

# ---------- DATA ----------
df <- read_excel("Excel_R_HIV1_resistancesummary.xlsx") |> clean_names()

# Consistent ordering (edit if you need a different order)
drug_order    <- c("3TC","ABC","DDI","DPV","EFV","ETR","FTC","NVP")
mutation_order <- c("E138A","K103N","K103N+V106I","M184V")
class_order   <- c("NNRTI","NRTI")  # left→right panel order

df <- df |>
  mutate(
    accession_number = factor(accession_number, levels = unique(accession_number)),
    resistant_drug   = factor(resistant_drug, levels = drug_order),
    driver_mutation  = factor(driver_mutation, levels = mutation_order),
    mutation_class   = factor(mutation_class, levels = class_order)
  )

# ---------- PLOT ----------
p <- ggplot(df, aes(x = accession_number, y = resistance_level)) +
  ggbeeswarm::geom_quasirandom(
    aes(
      fill  = resistant_drug,     # inside color follows drug
      shape = driver_mutation,    # simple shape for mutation
      group = resistant_drug      # ensures proper dodging by drug
    ),
    # Positioning to avoid overlap:
    dodge.width = 0.50,  # side-by-side separation by drug (tune 0.4–0.7)
    width       = 0.15,  # small within-group spread (tune 0.1–0.2)
    varwidth    = FALSE, # uniform spread across levels
    size        = 3.6,
    stroke      = 0.9,
    color       = "grey30", # outline/border
    alpha       = 0.95
  ) +
  # Legends & aesthetics
  scale_fill_brewer(palette = "Set2", name = "Resistant drug") +
  scale_shape_manual(
    name   = "Driver mutation",
    values = c(
      "E138A"        = 22,  # filled square
      "K103N"        = 24,  # filled triangle up
      "K103N+V106I"  = 23,  # filled diamond
      "M184V"        = 21   # filled circle
    )
  ) +
  # Axes
  scale_y_continuous(
    breaks = 0:5,
    limits = c(0.5, 5.5),
    expand = expansion(mult = c(0, 0.03))
  ) +
  
  labs(
    title = "Sequence_wise NRTI & NNRTI resistance profiles",
    x = "Accession number",
    y = "Resistance level"
  ) +
  # Two panels for mutation_class
  facet_wrap(~ mutation_class, nrow = 1) +
  
  # ---------- JOURNAL-STYLE THEME ----------
theme_minimal(base_size = 12) +
  theme(
    # Bold headings
    plot.title      = element_text(face = "bold", size = 14, margin = margin(b = 6)),
    plot.subtitle   = element_text(size = 11, margin = margin(b = 8)),
    axis.title.x    = element_text(face = "bold", size = 12, margin = margin(t = 6)),
    axis.title.y    = element_text(face = "bold", size = 12, margin = margin(r = 6)),
    strip.text      = element_text(face = "bold", size = 12),
    legend.title    = element_text(face = "bold", size = 11),
    legend.text     = element_text(size = 10),
    
    # Readability
    axis.text.x     = element_text(angle = 45, hjust = 1, vjust = 1, size = 10),
    axis.text.y     = element_text(size = 10),
    
    # Panel polish
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.border       = element_rect(color = "grey80", fill = NA, linewidth = 0.5),
    panel.spacing      = unit(10, "pt"),
    
    # Legends
    legend.position  = "right",
    legend.key.size  = unit(10, "pt"),
    legend.box       = "vertical"
  ) +
  guides(
    # Drug legend preview as filled circles for consistency
    fill  = guide_legend(order = 1,
                         override.aes = list(shape = 21, size = 4, color = "grey30", stroke = 0.9)),
    shape = guide_legend(order = 2)
    # No resistance_level legend needed (y-axis already shows it)
  )

p