function perform_error_estimate_chi()
  temperatures = [Constants.T_crit];
  % chi_values = [28, 30, 32];
  chi_values = [60, 62, 64];
  N_values = [3000];

  sim = FixedNSimulation(temperatures, chi_values, N_values).run();
  order_params = sim.compute(OrderParameter);

  error_estimate_finite_chi(chi_values, order_params)

end
