function plot_pseudocritical_temperature
  chi_values = [2, 4, 6, 8, 10, 12, 14, 16, 24, 32];
  filenames = {'t_stars_chi2-32_tol1e-8_TolX1e-5.mat', 't_stars_chi_tol1e-8_TolX1e-7.mat'};
  pseudocritical_temps = zeros(numel(chi_values), numel(filenames));

  for f = 1:numel(filenames)
    filename = filenames{f};
    result = load(filename);
    pseudocritical_temps(:, f) = result.t_stars;
  end

  differences = pseudocritical_temps(:, 1) - pseudocritical_temps(:, 2);

  markerplot(chi_values, differences)
  % hline(Constants.T_crit, '--', '$T_{c}^{\infty}$')
  xlabel('$\chi$')
  ylabel('$T_{c}^{\chi}$')
end
