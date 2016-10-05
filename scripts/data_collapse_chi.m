function data_collapse_chi
  chi_values = [6, 8, 12];
  pseudocritical_temps = arrayfun(@Constants.T_pseudocrit, chi_values)
  x_values = linspace(0.066666666666667, 0.266666666666667, 10);
  % x_values = linspace(-0.2, 0.4, 10);
  tolerances = [1e-7];

  DATABASE = fullfile(Constants.DB_DIR, 'scaling_function.db');
  db_id = sqlite3.open(DATABASE);
  calculate_corresponding_temperatures(x_values, chi_values, db_id);
  temperatures = retrieve_corresponding_temperatures(x_values, chi_values, db_id);
  sqlite3.close(db_id)

  order_parameters = zeros(numel(x_values), numel(chi_values));
  correlation_lengths = zeros(numel(x_values), numel(chi_values));

  for c = 1:numel(chi_values)
    sim = FixedToleranceSimulation(temperatures(:, c), [chi_values(c)], tolerances);
    sim = sim.run();
    order_parameters(:, c) = sim.compute(OrderParameter);
    correlation_lengths(:, c) = sim.compute(CorrelationLength);
  end


  % DO DATA COLLAPSE
  % Critical exponents
  % nu = 1, but we leave it out altogether.
  beta = 1/8;
  MARKERS = markers();

  figure
  hold on

  for c = 1:numel(chi_values)
    temperatures_chi = temperatures(:, c);
    T_pseudocrit = pseudocritical_temps(c);
    x_values = zeros(1, numel(temperatures_chi));
    scaling_function_values = zeros(1, numel(temperatures_chi));

    for t = 1:numel(temperatures_chi)
      x_values(t) = reduced_T_dot(temperatures_chi(t), T_pseudocrit) * correlation_lengths(t, c);
      scaling_function_values(t) = order_parameters(t, c) * correlation_lengths(t, c)^beta;
    end

    plot(x_values, scaling_function_values, MARKERS(mod(c, numel(MARKERS)) + 1));
  end

  make_legend(chi_values, '\chi')
  xlabel('$t\xi(\chi, T)^{1/\nu}$');
  ylabel('$m(T, \chi)\xi(\chi,T)^{\beta/\nu}$')
  title('Scaling ansatz for $\xi(\chi, T)$. Tolerance = $10^{-7}$. $|T - T_c| < 0.05$.', 'interpreter', 'latex')



  % Gives relative temperature measure that is zero at pseudocritical temperature of finite system.
  function t = reduced_T_dot(T, T_pseudocrit)
    t = (T - T_pseudocrit) / T_pseudocrit;
  end

  % Infinite system case
  function t = reduced_T(T)
    t = reduced_T_dot(T, Constants.T_crit);
  end
end

% find t * xi(chi, t) ^ (1/v) that equals x
% Used for finding equally spaced values for making a nice data collapse.
function calculate_corresponding_temperatures(x_values, chi_values, db_id)
  max_err = 1e-3;
  % round to 5 decimal places
  x_values = arrayfun(@(x) round(x, 5), x_values);
  temperatures = zeros(1, numel(x_values));
  width = 0.05;

  function stop = outfun(chi, temperature, optimValues, state)
    if strcmp(state, 'done') | optimValues.fval < max_err
      stop = true;
    elseif strcmp(state, 'init')
      stop = false;
    else
      x_value = Util.reduced_T(temperature) * ...
        calculate_correlation_length(temperature, chi);
      store_to_db(x_value, temperature, chi, 0, max_err);
      stop = false;
    end
  end

  for x_index = 1:numel(x_values)
    for chi_index = 1:numel(chi_values)
      %
      % outfun_chi = @(temperature, optimValues, state) outfun(chi_values(chi_index), temperature, optimValues, state);
      options = optimset('Display', 'iter', 'TolX', 1e-8, 'OutputFcn', @(temperature, optimValues, state) outfun(chi_values(chi_index), temperature, optimValues, state));

      if ~isempty(query_db(x_values(x_index), chi_values(chi_index), db_id))
        display(['Already in DB: ' num2str(x_values(x_index))])
        continue
      else
        f = @(temperature) (abs(Util.reduced_T(temperature) * calculate_correlation_length(temperature, chi_values(chi_index)) - x_values(x_index)));
        [temperature, err] = fminbnd(f, Constants.T_crit - width, Constants.T_crit + width, options)
        store_to_db(x_values(x_index), temperature, chi_values(chi_index), err, max_err)
      end
    end
  end

  function store_to_db(x, temperature, chi, err, max_err)
    x = round(x, 5);
    if err > max_err
      fprintf(['not storing this shit: error is ', num2str(err), '.\n'])
    else
      query = 'insert into scaling_function (x, temperature, chi, error) values (?, ?, ?, ?);';
      sqlite3.execute(db_id, query, x, temperature, chi, err);
      fprintf('stored that shit to db.\n')
    end
  end
end

function temperatures = retrieve_corresponding_temperatures(x_values, chi_values, db_id)
  temperatures = zeros(numel(x_values), numel(chi_values));
  for x_index = 1:numel(x_values)
    for chi_index = 1:numel(chi_values)
      result = query_db(x_values(x_index), chi_values(chi_index), db_id);
      temperatures(x_index, chi_index) = result.temperature;
    end
  end
end

function xi = calculate_correlation_length(temperature, chi)
  if temperature < 0
    xi = 0;
  elseif temperature > 20
    error('hou maar op')
  else
    tolerance = 1e-7;
    sim = FixedToleranceSimulation([temperature], [chi], [tolerance]).run();
    xi = sim.compute(CorrelationLength);
  end
end

function result = query_db(x, chi, db_id)
  x = round(x, 5);
  query = 'select * from scaling_function where x = ? AND chi = ?;';
  result = sqlite3.execute(db_id, query, x, chi);
end
