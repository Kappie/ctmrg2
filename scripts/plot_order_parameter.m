function plot_order_parameter
  % chi_values = [4, 6, 8, 10];
  % tolerances = [1e-7];
  % width = 0.02;
  % number_of_points = 10;
  % temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, number_of_points);
  %
  % sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  % order_params = sim.compute(OrderParameter);
  %
  % markerplot(temperatures, order_params)
  % make_legend(chi_values, '\chi')
  % line = vline(Constants.T_crit, '--');
  % set(line, 'Color', 'black')
  % xlabel('$T$')
  % ylabel('$|m|$')


  % chi_values = [32];
  % N_values = [200, 400, 600, 800];
  % sim = FixedNSimulation(temperatures, chi_values, N_values).run();
  % order_params = sim.compute(OrderParameter);
  %
  % markerplot(temperatures, order_params)
  % make_legend(N_values, 'N')
  % line = vline(Constants.T_crit, '--');
  % set(line, 'Color', 'black')
  % xlabel('$T$')
  % ylabel('$|m|$')
end
