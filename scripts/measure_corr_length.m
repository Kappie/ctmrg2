function measure_corr_length
  temperatures = [Constants.T_crit, Constants.T_pseudocrit(32)];
  chi_values = [32];
  tolerances = [1e-4, 1e-5, 1e-6, 1e-7, 1e-8, 1e-9];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  corr_lengths = sim.compute(CorrelationLength)

  markerplot(tolerances, corr_lengths, 'semilogx')

  make_legend(temperatures, 'T')


end

function extrapolate_to_infinite_N(temperature, chi)
  max_steps = 1e4;
  min_steps = round(0.9 * max_steps);
  number_of_steps = 10
  N_values = arrayfun(@round, linspace(min_steps, max_steps, number_of_steps));

  sim = FixedNSimulation([temperature], [chi])



end
