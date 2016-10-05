function tensor_struct = find_or_calculate_environment(obj, temperature, chi, N)
  % Checks if converged tensors are already in the database.
  % If tensors already exist, do nothing.
  % If tensors with same temperature and chi, but with lower N exist,
  % use those as a starting point and add the remaining amount of steps required.

  query = ['SELECT * ' ...
    'FROM tensors ' ...
    'WHERE temperature = ? AND chi = ? AND n <= ? ' ...
    'ORDER BY n DESC ' ...
    'LIMIT 1'];
  query_result = sqlite3.execute(query, temperature, chi, N);

  if isempty(query_result) || ~obj.LOAD_FROM_DB
    display('Did not find record');
    iterations_remaining = N;
    initial_C = obj.initial_C(temperature);
    initial_T = obj.initial_T(temperature);
    [C, T, convergence] = obj.calculate_environment(temperature, chi, iterations_remaining, initial_C, initial_T);
  else
    iterations_remaining = N - query_result.n;
    display(['Found record: ' num2str(iterations_remaining) ' iterations remaining.'])
    if iterations_remaining > 0
      [initial_C, initial_T] = Util.deserialize_tensors(query_result);
      [C, T, convergence] = obj.calculate_environment(temperature, chi, iterations_remaining, initial_C, initial_T);
    else
      % 0 iterations remaining, nothing to simulate!
      [C, T] = Util.deserialize_tensors(query_result);
    end
  end

  if iterations_remaining > 0
    obj.save_to_db(temperature, chi, N, convergence, C, T);
  end

  tensor_struct = struct('C', C, 'T', T);
end
