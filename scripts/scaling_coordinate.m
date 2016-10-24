function scaling_coordinate
  number_of_points = 18;
  chi_values = [8, 16, 24, 32];
  tolerance = 1e-8;
  % previously: x_max = 0.1, 0.5, 1, 3
  x_max = 3;


  nu = 1;
  beta = 1/8;

  x_values = zeros(number_of_points, numel(chi_values));
  scaling_function_values = zeros(number_of_points, numel(chi_values));
  temperatures = zeros(number_of_points, numel(chi_values));
  reduced_temperatures = zeros(number_of_points, numel(chi_values));
  correlation_lengths = zeros(number_of_points, numel(chi_values));
  order_parameters = zeros(number_of_points, numel(chi_values));

  for c = 1:numel(chi_values)
    width = t_max(x_max, chi_values(c));
    temperatures(:, c) = linspace(Constants.T_crit - width, Constants.T_crit + width, number_of_points);
    reduced_temperatures(:, c) = arrayfun(@Constants.reduced_T, temperatures(:, c));

    sim = FixedToleranceSimulation(temperatures(:, c), [chi_values(c)], [tolerance]).run();
    correlation_lengths(:, c) = sim.compute(CorrelationLength);
    order_parameters(:, c) = sim.compute(OrderParameterStrip);

    x_values(:, c) = reduced_temperatures(:, c) .* correlation_lengths(:, c).^(1/nu);
    scaling_function_values(:, c) = correlation_lengths(:, c).^(beta/nu) .* order_parameters(:, c);
  end

  % markerplot(reduced_temperatures, x_values)
  markerplot(x_values, scaling_function_values)
  make_legend(chi_values, '\chi')
  xlabel('$t\xi(\chi)^{1/\nu}$')
  ylabel('$\xi(\chi)^{\beta/\nu}m(t, \chi)$')
  % ylabel('$t\xi(\chi)$')
  % hline(0, '-', 't = 0')

  % x_values = zeros(numel(temperatures), numel(chi_values));
  %
  % for t = 1:numel(temperatures)
  %   for c = 1:numel(chi_values)
  %     x_values(t, c) = x_value(temperatures(t), chi_values(c), tolerance);
  %   end
  % end
  %
  % markerplot(arrayfun(@Constants.reduced_T, temperatures), x_values);
  % xlabel('$t$')
  % ylabel('$t\xi(\chi)^{\frac{1}{\nu}}$')
  % make_legend(chi_values, '\chi')
  % hline(0, '-', 't = 0')
end

function xi = calculate_correlation_length(temperature, chi, tolerance)
  sim = FixedToleranceSimulation([temperature], [chi], [tolerance]).run();
  xi = sim.compute(CorrelationLength);
end

function x = x_value(temperature, chi, tolerance)
  nu = 1;
  x = Constants.reduced_T(temperature) * calculate_correlation_length(temperature, chi, tolerance)^nu;
end

function t_max = t_max(x_max, chi)
  % This function aims to calculate a suitable width (t_max) around the critical point
  % (t = 0) in which temperatures should fall if the scaling coordinate is to have value
  % at most (approximately) x_max.

  % values from loglog plot of chi vs correlation length.
  % xi = a * chi ^ kappa
  kappa = 2;
  a = 0.82;

  t_max = (1/a)*x_max*chi^(-kappa);
  t_max = round(t_max, 1, 'significant');

  % This seems to make it work better...
  t_max = t_max / 10;
end
