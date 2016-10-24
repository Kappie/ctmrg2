function plot_ctm
  temperatures = [Constants.T_crit];
  chi_values = 6:2:12;
  tolerances = [1e-9];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  % sim.LOAD_FROM_DB = false; sim.SAVE_TO_DB = false;
  sim = sim.run();
  tensors = sim.tensors;

  figure
  hold on
  MARKERS = markers();
  line_handles = zeros(1, numel(chi_values))

  for c = 1:numel(chi_values)
    [C, T, singular_values, truncation_error, full_singular_values] = sim.grow_lattice( ...
      temperatures(1), chi_values(c), tensors(c).C, tensors(c).T);
    included_singular_values = full_singular_values(1:chi_values(c));
    thrown_away_singular_values = full_singular_values(chi_values(c) + 1:end)
    plot(chi_values(c)+1:2*chi_values(c), thrown_away_singular_values, [MARKERS(c) '--'])
    line_handles(c) = plot(1:chi_values(c), included_singular_values, [MARKERS(c) '--']);
  end

  hold off

  legend_labels = arrayfun(@(value) ['$' '\chi' ' = ' num2str(value) '$'], chi_values, 'UniformOutput', false);
  legend(line_handles, legend_labels)
  set(gca, 'YScale', 'log')
  xlabel('$i$')
  ylabel('$C_i$')
end
