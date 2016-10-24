function plot_eigenvalues_transfer_matrix
  width = 0.1;
  temperatures = Util.linspace_around_T_crit(width, 9);
  reduced_temperatures = Constants.reduced_Ts(temperatures);
  chi_values = [16];
  tolerances = [1e-7];

  global number_of_eigvals;
  global eigenvalues;
  number_of_eigvals = 4
  eigenvalues = zeros(0, number_of_eigvals);

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  order_params = sim.compute(OrderParameterStrip);

  markerplot(temperatures, eigenvalues)
  eigenvalues

  vline(Constants.T_crit, '--')
  xlabel('$T$');
  legend_labels = arrayfun(@(x) ['$\lambda_{' num2str(x) '}$'], 1:number_of_eigvals, 'UniformOutput', false)
  legend(legend_labels, 'Location', 'best')
  title('$\chi = 16$, tolerance = $10^{-7}$')
end
