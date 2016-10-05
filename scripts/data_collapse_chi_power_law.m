function data_collapse_chi_power_law
  % Gather neccessary measurements of order parameter
  % chi_values = [4, 8, 10, 14, 16, 24, 32];
  chi_values = [16, 32];
  tolerances = [1e-7];
  temperature_width = 0.001;
  T_pseudocrits = arrayfun(@Constants.T_pseudocrit, chi_values);
  epsilon = 1e-9;
  number_of_points = 10;
  % temperatures = zeros(number_of_points, numel(chi_values));
  % order_params = zeros(number_of_points, numel(chi_values));

  % for c = 1:numel(chi_values)
  %   temperatures(:, c) = linspace(T_pseudocrits(c) - temperature_width, ...
  %     T_pseudocrits(c) - epsilon, number_of_points);
  %   sim = FixedToleranceSimulation(temperatures(:, c), [chi_values(c)], tolerances).run();
  %   order_params(:, c) = sim.compute(OrderParameter);
  % end

  temperatures = linspace(Constants.T_crit - temperature_width, ...
    Constants.T_crit + epsilon, number_of_points);
  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  order_params = sim.compute(OrderParameter);
  % temperatures_extra = linspace(Constants.T_crit - epsilon, Constants.T_pseudocrit(chi_values(end)), number_of_points);
  % temperatures = [temperatures temperatures_extra];
  % temperatures_zoom = linspace(Constants.T_crit - temperature_width/10, ...
  %   Constants.T_crit + temperature_width/10, number_of_points);
  % temperatures = [temperatures temperatures_zoom];

  % DO DATA COLLAPSE
  %
  % Critical exponents
  beta = 1/8;
  kappa = Constants.kappa();
  nu = 1;

  MARKERS = markers();
  figure
  hold on

  for c = 1:numel(chi_values)
    % temperatures_chi = temperatures(:, c);
    % x_values = zeros(1, numel(temperatures_chi));
    x_values = zeros(1, numel(temperatures));
    % scaling_function_values = zeros(1, numel(temperatures_chi));
    scaling_function_values = zeros(1, numel(temperatures));

    % reduced_T_dots = arrayfun(@(temp) Constants.reduced_T_dot(temp, T_pseudocrits(c)), temperatures_chi)
    % reduced_Ts = arrayfun(@Constants.reduced_T, temperatures_chi)

    for t = 1:numel(temperatures)
      % x_values(t) = Constants.reduced_T_dot(temperatures(t), T_pseudocrits(c)) * chi_values(c)^(kappa/nu);
      % x_values(t) = Constants.reduced_T(temperatures_chi(t)) * chi_values(c)^(kappa/nu);
      x_values(t) = Constants.reduced_T(temperatures(t)) * chi_values(c)^(kappa/nu);
      scaling_function_values(t) = chi_values(c)^(beta*kappa/nu) * order_params(t, c);
    end
    plot(x_values, scaling_function_values, MARKERS(mod(c, numel(MARKERS)) + 1))
    % markerplot(x_values, scaling_function_values)
  end

  xlabel('$t\chi^{\kappa/\nu}$')
  ylabel('$\chi^{\kappa\beta/\nu}m(t, \chi, N \to \infty)$')
  make_legend(chi_values, '\chi')


  function t = reduced_T(T)
    t = (T - Constants.T_crit) / Constants.T_crit;
  end
end
