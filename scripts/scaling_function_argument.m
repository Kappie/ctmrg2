% find t * xi(chi, t) ^ (1/v) that equals x
% Used for finding equally spaced values for making a nice data collapse.
function scaling_function_argument
  tolerance = 1e-3;
  DATABASE = fullfile(Constants.DB_DIR, 'scaling_function.db');
  db_id = sqlite3.open(DATABASE);
  chi_values = [16, 24, 32];
  x_values = linspace(-0.2, 0.4, 10);
  % x_values = [0.4];
  % round to 5 decimal places
  x_values = arrayfun(@(x) round(x, 5), x_values);
  temperatures = zeros(1, numel(x_values));
  width = 0.05;
  options = optimset('Display', 'iter', 'TolX', 1e-8, 'OutputFcn', @outfun);

  function stop = outfun(temperature, optimValues, state)
    if strcmp(state, 'done') | optimValues.fval < tolerance
      stop = true;
    else
      stop = false;
    end
  end

  for x_index = 1:numel(x_values)
    for chi_index = 1:numel(chi_values)
      if is_in_db(x_values(x_index), chi_values(chi_index))
        display(['Already in DB: ' num2str(x_values(x_index))])
        continue
      else
        f = @(temperature) (abs(Util.reduced_T(temperature) * calculate_correlation_length(temperature, chi_values(chi_index)) - x_values(x_index)));
        [temperature, err] = fminbnd(f, Constants.T_crit - width, Constants.T_crit + width, options)
        store_to_db(x_values(x_index), temperature, chi_values(chi_index), err)
      end
    end
  end

  sqlite3.close(DATABASE);

  function result = is_in_db(x, chi)
    x = round(x, 5);
    query = 'select * from scaling_function where x = ? AND chi = ?;';
    query_result = sqlite3.execute(db_id, query, x, chi);
    result = ~isempty(query_result);
  end

  function store_to_db(x, temperature, chi, err)
    x = round(x, 5);
    if err > tolerance
      fprintf(['not storing this shit: error is ', num2str(err), '.\n'])
    else
      query = 'insert into scaling_function (x, temperature, chi, error) values (?, ?, ?, ?);';
      sqlite3.execute(db_id, query, x, temperature, chi, err);
      fprintf('stored that shit to db.\n')
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
