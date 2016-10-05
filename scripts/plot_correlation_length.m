function plot_correlation_length
  temperature_width = 1e-2;
  temperatures = linspace(Constants.T_crit - temperature_width, Constants.T_crit + temperature_width, 10);
  temperatures_zoom = linspace(Constants.T_crit - temperature_width/10, Constants.T_crit + temperature_width/10, 10);
  temperatures = sort([temperatures temperatures_zoom]);
  chi_values = [8, 16, 32]
  tolerances = [1e-7];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  sim = sim.run();
  correlation_lengths = sim.compute(CorrelationLength);

  markerplot(temperatures, correlation_lengths)
  axis manual
  line([Constants.T_crit, Constants.T_crit], [0, 10000000], 'LineStyle', '--');
  make_legend(chi_values, '$\chi$')
  xlabel('$T$')
  ylabel('$\xi(\chi)$')
  % export_fig(fullfile(Constants.PLOTS_DIR, 'correlation_length_vs_t_tol1e-7_width1e-2.pdf'))
end
