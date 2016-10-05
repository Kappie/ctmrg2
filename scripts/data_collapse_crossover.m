function data_collapse_crossover
  temperature_width = 1e-2;
  temperatures = linspace(Constants.T_crit - temperature_width, Constants.T_crit + temperature_width, 10);
  chi_values = 4:2:16;
  N_values = [100, 200, 500, 1000, 2000, 4000, 10000];

  sim = FixedNSimulation(temperatures, chi_values, N_values);
  sim = sim.run();
  order_parameters = sim.compute(OrderParameter);
  correlation_lengths = sim.compute(CorrelationLength);

  sort(correlation_lengths(:));

  % DO DATA COLLAPSE
  % Critical exponents
  % nu = 1, but we leave it out altogether.
  beta = 1/8;
  MARKERS = markers();

  figure
  hold on

  for c = 1:numel(chi_values)
    x_values = zeros(1, numel(temperatures));
    scaling_function_values = zeros(1, numel(temperatures));

    for t = 1:numel(temperatures)
      x_values(t) = reduced_T(temperatures(t)) * correlation_lengths(t, c);
      scaling_function_values(t) = order_parameters(t, c) * correlation_lengths(t, c)^beta;
    end

    plot(x_values, scaling_function_values, MARKERS(mod(c, numel(MARKERS)) + 1));
  end

  make_legend(chi_values, 'chi')
  xlabel('$t\xi(\chi, t)^{1/\nu}$');
  ylabel('$m(t, \chi)\xi(\chi,t)^{\beta/\nu}$')

  export_fig(fullfile(Constants.PLOTS_DIR, 'data_collapse_chi_tol1e-7_chi2-32_width1e-1and1e-2and1e-3.pdf'));

  function t = reduced_T(T)
    t = (T - Constants.T_crit) / Constants.T_crit;
  end
end
