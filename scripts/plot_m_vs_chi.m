function plot_m_vs_chi
  temperatures = [Constants.T_crit];
  chi_values = 8:2:64;
  % N_values = [100, 200, 500, 1000, 1500, 2000];
  N_values = 2000;

  sim = FixedNSimulation(temperatures, chi_values, N_values).run();
  order_params = sim.compute(OrderParameter);

  markerplot(1./chi_values, order_params)
  xlabel('$ 1 / \chi $')
  ylabel('$|m|$')
  make_legend(N_values, 'N')

  error_estimate_finite_chi(chi_values, order_params)
end
