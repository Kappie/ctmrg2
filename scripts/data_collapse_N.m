function data_collapse_N
  % Gather neccessary measurements of order parameter
  temperature_width = 0.5;
  temperatures = linspace(Constants.T_crit - temperature_width, Constants.T_crit + temperature_width, 9);
  N_values = 25:25:1000;
  chi = 32;

  sim = FixedNSimulation(temperatures, [chi], N_values).run();
  order_params = sim.compute(OrderParameter);

  % DO DATA COLLAPSE
  %
  % Critical exponents
  % nu = 1, but we leave it out altogether.
  beta = 1/8;

  MARKERS = markers();
  figure
  hold on

  for n = 1:numel(N_values)
    x_values = zeros(1, numel(temperatures));
    scaling_function_values = zeros(1, numel(temperatures));

    for t = 1:numel(temperatures)
      x_values(t) = reduced_T(temperatures(t)) * N_values(n);
      scaling_function_values(t) = N_values(n)^beta * order_params(t, n);
    end

    plot(x_values, scaling_function_values, MARKERS(mod(n, numel(MARKERS)) + 1))
  end

  xlabel('$ tN^{1/\nu} $', 'interpreter', 'latex')
  ylabel('$N^{\beta/\nu}m(t, N)$', 'interpreter', 'latex')
  title('Data collapse for scaling ansatz in N (number of steps). $\chi = 32$. $25 \leq N \leq 1000$. $|T - T_c| \leq 0.5$')

  % make_legend(N_values, 'N')

  function t = reduced_T(T)
    t = (T - Constants.T_crit) / Constants.T_crit;
  end
end
