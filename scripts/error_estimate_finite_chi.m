function error = error_estimate_finite_chi(chi_values, order_params)
  points = 3;
  order_params = order_params(end-points+1:end);
  chi_values = chi_values(end-points+1:end);

  fit = polyfit(1./chi_values, order_params, 1);
  infinite_chi_limit = fit(2);
  error = 100 * (order_params(end) - infinite_chi_limit) / infinite_chi_limit;
end
