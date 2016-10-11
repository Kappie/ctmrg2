function calculate_kappa
  temperatures = [Constants.T_crit];
  chi_values = 16:2:64;
  % chi_values = [4, 8]
  tolerances = [1e-9];
  beta = 1/8; nu = 1;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  % sim.SAVE_TO_DB = false; sim.LOAD_FROM_DB = false;
  sim = sim.run();
  % corr_lengths = sim.compute(CorrelationLength);
  load('correlation_lengths_chi16-64.mat', 'corr_lengths')
  order_params = sim.compute(OrderParameter);

  [total_slope1, ~] = logfit(chi_values, order_params, 'loglog');
  [total_slope2, ~] = logfit(chi_values, corr_lengths, 'loglog');
  % slope; %    1.940045384131416
  % METHOD 1: calculate by scaling of correlation length at T_crit
  number_of_points = 15;
  number_of_fits = numel(chi_values) - number_of_points;
  kappa_values = zeros(2, number_of_fits);

  for index = 1:number_of_fits
    [slope1, ~] = logfit(chi_values, order_params, 'loglog', 'skipBegin', index, 'skipEnd', numel(chi_values) - (index + number_of_points));
    [slope2, ~] = logfit(chi_values, corr_lengths, 'loglog', 'skipBegin', index, 'skipEnd', numel(chi_values) - (index + number_of_points));
    kappa_values(1, index) = -8*slope1;
    kappa_values(2, index) = slope2;
  end


  markerplot(chi_values(1:number_of_fits), kappa_values);
  hline(Constants.kappa, '--', '$\kappa_{\mathrm{exact}}$');
  % hline(total_slope2, '--', )
  % hline(-8*total_slope1, '--', '$\kappa_{m}$')
  xlabel('$\chi_{\mathrm{start}}$')
  ylabel('$\kappa$')
  % legend_labels = {'extracted from $m$', 'extracted from $\xi$'}
  % legend(legend_labels, 'Location', 'best')

  % xlabel('$\chi$')
  % ylabel('$\xi(t = 0, \chi)$')
  % legend_labels = {'data', ['$\kappa$ = ' num2str(slope)]}
  % legend(legend_labels, 'Location', 'northwest')

  %%% METHOD 2: calculate by scaling of order parameter at T_crit
  % [slope, intercept] = logfit(chi_values, order_params, 'loglog')
  % legend_labels = {'data', ['$-\frac{\kappa \beta}{\nu}$ = ' num2str(slope)]}
  % legend(legend_labels, 'Location', 'northeast')
  % -Constants.kappa * beta / nu
  % -8 * slope %    1.943357139641346
  % xlabel('$\chi$')
  % ylabel('$m(t = 0, \chi)$')



end
