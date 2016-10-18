function plot_ctm
  temperatures = [Constants.T_crit];
  chi_values = [4];
  tolerances = [1e-9];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run()
  tensors = sim.tensors
  [C, T, singular_values, truncation_error] = sim.grow_lattice( ...
  temperatures(1), chi_values(1), tensors(1).C, tensors(1).T)

end
