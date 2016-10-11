function plot_pseudocritical_temperature
  chi_values = [2, 4, 6, 8, 10, 12, 14, 16, 24, 32];
  pseudocritical_points = arrayfun(@Constants.T_pseudocrit, chi_values) %- Constants.T_crit;

  markerplot(chi_values, pseudocritical_points)
  hline(Constants.T_crit, '--', '$T_{c}^{\infty}$')
  xlabel('$\chi$')
  ylabel('$T_{c}^{\chi}$')

  % [slope, intercept] = logfit(chi_values, pseudocritical_points, 'loglog')
  % Constants.kappa
  % % yApprox = (10^intercept)*chi_values.^(slope);
  % xlabel('$\chi$')
  % ylabel('$T_{c}(\chi) - T_c$')
  % legend_labels = {'data', ['$-\kappa / \nu = $' num2str(slope)]};
  % legend(legend_labels)
end
