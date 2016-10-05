function calculate_kappa
  temperatures = [Constants.T_crit];
  chi_values = [8, 10, 12, 14, 16];
  tolerances = [1e-7];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  corr_lengths = sim.compute(CorrelationLength);
  order_params = sim.compute(OrderParameter);

  % [slope, intercept] = logfit(chi_values, corr_lengths, 'loglog', 'skipBegin', 0)
  % Constants.kappa

  chi_values
  order_params
  [slope, intercept] = logfit(chi_values, order_params, 'loglog')
  beta = 1/8; nu = 1;
  -Constants.kappa * beta / nu


end
