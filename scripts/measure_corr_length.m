function measure_corr_length
  temperatures = [Constants.T_crit];
  chi_values = [16];

  for temp = temperatures
    for chi = chi_values
      extrapolate_to_infinite_N(temp, chi, OrderParameter)
    end
  end
end

function answer = extrapolate_to_infinite_N(temperature, chi, quantity)
  log_tolerance_begin = -8;
  log_tolerance_end = -9;
  number_of_points = 30;
  tolerances = logspace(log_tolerance_begin, log_tolerance_end, number_of_points);
  sim = FixedToleranceSimulation([temperature], [chi], tolerances).run();
  quantities = sim.compute(quantity);
  N_values = get_N_values(temperature, chi, tolerances, sim.DATABASE);
  answer = extrapolate(N_values, quantities');
end

function answer = extrapolate(N_values, quantities)
  points_to_use = 5;
  N_values = N_values(end - points_to_use + 1:end)
  quantities = quantities(end - points_to_use + 1:end)
  order = 1;
  p = polyfit(1./N_values, quantities, order);
  N_values_fit = linspace(N_values(1), N_values(end));
  quantities_fit = polyval(p, 1./N_values_fit);

  figure
  hold on
  markerplot(1./N_values, quantities);
  plot(1./N_values_fit, quantities_fit);
  hold off

  answer = p(order + 1);
end

function N_values = get_N_values(temperature, chi, tolerances, db)
  query = 'SELECT n FROM tensors WHERE temperature = ? AND chi = ? AND convergence = ?';
  db_id = sqlite3.open(db);
  N_values = zeros(1, numel(tolerances));

  for i = 1:numel(tolerances)
    result = sqlite3.execute(db_id, query, temperature, chi, tolerances(i));
    N_values(i) = result.n;
  end

  sqlite3.close(db_id);
end
