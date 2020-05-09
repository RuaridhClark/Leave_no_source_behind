# Leave_no_source_behind
Code developed for manuscript: *Leave no source behind; data sink selection for a ground station and spacecraft constellation network*. CN McGrath, RA Clark, M Macdonald.

**Run_optimiser.m** - select between consensus or maximum flow based optimiser of sink nodes in a flow network

**Adj_100day.mat** - weighted adjacency matrix of 250 ground-targets, 84 satellites, and 77 ground stations where connections are weighted by contact time. Except for ground station to satellite contacts where the contact time is divided by the number of satellites in view of the same ground station at the same time step.

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.3818217.svg)](http://dx.doi.org/10.5281/zenodo.3818217)
