function find_pseudocritical_point
  % chi_values = [2, 4, 6, 8, 10, 12, 14, 16, 24, 32];
  chi_values = [2];
  tolerance = 1e-8;
  t_width = 0.3;

  t_stars = zeros(1, numel(chi_values));
  corr_lengths = zeros(1, numel(chi_values));
  negative_xi = @(temperature, chi, tolerance) -1 * calculate_correlation_length(temperature, chi, tolerance);
  options = optimset('Display', 'iter', 'TolX', 1e-5);

  for c = 1:numel(chi_values)
    optim_func = @(temperature) negative_xi(temperature, chi_values(c), tolerance);
    [t_star, corr_length] = fminbnd(optim_func, ...
      Constants.T_crit - t_width, Constants.T_crit + t_width, options);

    t_stars(c) = t_star;
    corr_lengths(c) = corr_length;
    save('t_stars_chi2_tol1e-8_TolX1e-7_alternate.mat', 'chi_values', 't_stars', 'corr_lengths')
  end


end

function xi = calculate_correlation_length(temperature, chi, tolerance)
  if temperature < 0
    xi = 0;
  elseif temperature > 20
    error('hou maar op')
  else
    sim = FixedToleranceSimulation([temperature], [chi], [tolerance]).run();
    xi = sim.compute(CorrelationLength2);
  end
end

function filename = filename(chi)
  filename = ['t_stars_chi' num2str(chi) '_tol1e-8_TolX1e-5.mat']
end
