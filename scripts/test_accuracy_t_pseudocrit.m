function test_accuracy_t_pseudocrit
  chi_values = [16];
  pseudocritical_temps = arrayfun(@Constants.T_pseudocrit, chi_values);
  tolerances = [1e-7, 1e-8, 1e-9];

  sim = FixedToleranceSimulation(pseudocritical_temps, chi_values, tolerances).run();
  corr_lengths = sim.compute(CorrelationLength)
end
