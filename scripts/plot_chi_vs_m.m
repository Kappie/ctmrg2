function plot_chi_vs_m
  temperatures = [Constants.T_crit];
  chi_values = 10:2:20;
  N_values = [1000, 5000, 10000];

  sim = FixedNSimulation(temperatures, chi_values, N_values).run();
  order_parameters = sim.compute(OrderParameter)

  beta = 1/8; nu = 1; kappa = Constants.kappa;
  markerplot(chi_values.^(-beta*nu/kappa), order_parameters);
  make_legend(N_values, 'N')
  xlabel('$\chi^{-\frac{\kappa \beta}{\nu}}$')
  ylabel('$|m|$')
end
