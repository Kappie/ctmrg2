function plot_ms_vs_tolerance
  temperatures = [Constants.T_crit];
  tolerances = [1e-1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8];
  chi_values = [16, 32, 48, 64];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  order_params = sim.compute(OrderParameter);
  size(order_params)

  markerplot(tolerances, order_params, 'semilogx')
  xlabel('tolerance')
  ylabel('$|m|$')
  make_legend(chi_values, '$\chi$')

end
