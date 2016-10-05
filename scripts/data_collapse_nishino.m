function data_collapse_nishino
  temperatures = [Constants.T_crit];
  % chi_values = [4, 16, 32, 64];
  % chi_values = [4, 16, 32, 64]
  chi_values = [14 16];
  tolerances = [1e-7];
  % N_values = [20, 40, 60, 80, 100, 200, 300, 400, 500, 750, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 10000, 12000, 14000, 16000, 18000, 20000, 22000, 24000, 30000, 40000, 50000, 60000];
  % N_values = [rounded_powerspace(-1, 0.0002, 0.01, 30) rounded_powerspace(-1, 0.01, 0.2, 30)];
  % N_values = [50:25:500 550:50:950 1000:500:50000];
  % N_values = [50:50:200 250:250:15000 16000:3000:106000];
  N_values = [150:50:500 1000:1000:19000 20000:4000:60000];
  % N_values = [50 100]

  % Compute xi(chi)
  % sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  % correlation_lengths = sim.compute(CorrelationLength);

  % Compute m(N, chi)
  sim = FixedNSimulation(temperatures, chi_values, N_values).run();
  order_parameters = sim.compute(OrderParameter);

  % DO DATA COLLAPSE
  beta = 1/8;
  kappa = Constants.kappa;
  nu = 1;

  figure
  hold on
  MARKERS = markers();

  for c = 1:numel(chi_values)
    x_values = numel(N_values);
    scaling_function_values = numel(N_values);

    for n = 1:numel(N_values)
      x_values(n) = chi_values(c)^kappa / N_values(n);
      scaling_function_values(n) = order_parameters(c, n) * chi_values(c)^(kappa*beta/nu);
    end

    plot(x_values, scaling_function_values, MARKERS(mod(c, numel(MARKERS)) + 1));
  end

  % for c = 1:numel(chi_values)
  %   x_values = numel(N_values);
  %   scaling_function_values = numel(N_values);
  %
  %   for n = 1:numel(N_values)
  %     x_values(n) = chi_values(c)^kappa / N_values(n);
  %     scaling_function_values(n) = order_parameters(c, n) * N_values(n)^(beta/nu);
  %   end
  %
  %   plot(x_values, scaling_function_values, MARKERS(mod(c, numel(MARKERS)) + 1));
  % end

  make_legend(chi_values, '\chi');
  xlabel('$\chi^{\kappa} / N$')
  ylabel('$m(N, \chi, t = 0) \chi^{\kappa \beta/\nu}$')
  axis([0 0.4 0.75 1])
end
