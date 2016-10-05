function plot_m_vs_T
  width = 0.01;
  temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, 9);
  chi_values = [16];
  N_values = [1500];

  sim = FixedNSimulation(temperatures, chi_values, N_values);
  order_params = sim.compute(OrderParameter);
  markerplot(temperatures, order_params)
  axis manual
  line([Constants.T_crit, Constants.T_crit], [0, 10], 'LineStyle', '--');

end
