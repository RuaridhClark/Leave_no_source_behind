# Leave_no_source_behind
Code developed for manuscript: *Data sink selection using consensus leadership: improving target connectivity for a spacecraft constellation*. RA Clark, CN McGrath, M Macdonald.

**Run_optimiser.m** - select between consensus or maximum flow based optimiser of sink nodes in a flow network

**Adj_100day.mat** - weighted adjacency matrix of 250 ground-targets, 84 satellites, and 77 ground stations where connections are weighted by contact time. Except for ground station to satellite contacts where the contact time is divided by the number of satellites in view of the same ground station at the same time step.

**Adj2_100day_mf.mat** - weighted 2-hop adjacency matrix of 250 ground-targets, 84 satellites, and 77 ground stations where connections are weighted by maximum flow between each source and sink as required for the consensus-based optimiser.

[![DOI](https://zenodo.org/badge/262521072.svg)](https://zenodo.org/badge/latestdoi/262521072)
