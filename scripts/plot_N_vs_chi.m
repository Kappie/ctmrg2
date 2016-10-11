function plot_N_vs_chi
  temperatures = [Constants.T_crit];
  chi_values = [4, 16, 64];
  N_values = rounded_powerspace(-1/8, 0.2, 0.7, 30);

  sim = FixedNSimulation(temperatures, chi_values, N_values).run();
  order_parameters = sim.compute(OrderParameter)

  markerplot(N_values.^(-1/8), order_parameters);
  make_legend(chi_values, '\chi')
  xlabel('$N^{-1/8}$')
  ylabel('$|m|$')
end
