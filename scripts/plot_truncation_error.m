function plot_truncation_error
  temperatures = [Constants.T_crit];
  chi_values = 6:2:32;
  tolerances = [1e-9];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  tensors = sim.tensors;

  truncation_errors = zeros(1, numel(chi_values));

  for c = 1:numel(chi_values)
    [C, T, singular_values, truncation_error, full_singular_values] = sim.grow_lattice( ...
      temperatures(1), chi_values(c), tensors(c).C, tensors(c).T);
    truncation_errors(c) = truncation_error;
  end

  markerplot(chi_values, truncation_errors)
  xlabel('$\chi$')
  ylabel('Truncation error')
end
